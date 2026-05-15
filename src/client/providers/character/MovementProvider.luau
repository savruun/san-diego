--!strict

const TweenService = game:GetService('TweenService')
const EzInput = require('@pkg/ezinput')
const Charm = require('@pkg/charm')

const dependency = require('@pkg/quill_dependencies')
const constants = require('@shared/constants')
const timer = require('@shared/lib/Timer')

const MAX_STAMINA = constants.MAX_STAMINA
const STAMINA_DRAIN_RATE = constants.STAMINA.DRAIN_RATE
const STAMINA_REGEN_RATE = constants.STAMINA.REGEN_RATE
const SPRINT_COOLDOWN = constants.SPRINT_COOLDOWN

const MovementProvider = {
  isSprinting = false, stamina = Charm.atom(MAX_STAMINA),
  sprintCooldownTimer = nil :: timer.Timer?,
  character = nil :: Model?,
  humanoid = nil :: Humanoid?
}

MovementProvider.CharacterProvider = dependency.use(require('./CharacterProvider'))

function MovementProvider.start (self: self): ()
  self:_attachToCharacter()
  self:_attachInput()
  print('started')
end

--[[
  Update sprint stamina and whatnot every RunService.Heartbeat
]]
function MovementProvider.on_heartbeat(delta: number): ()
  local stamina = MovementProvider.stamina()
	local timerObj = MovementProvider.sprintCooldownTimer

  -- Even tho the function checks if the timer obj is not nil, we need to have the assertion here for type safety
  if MovementProvider:isSprintOnCooldown() and timerObj ~= nil then
    timerObj:update(delta)
    return
  elseif timerObj then
    MovementProvider:setSprintCooldown(false)
  end

  if MovementProvider.isSprinting then
    -- If the stamina is less than 0 then use 0
    local new = math.max(0, stamina - (STAMINA_DRAIN_RATE * delta))
    MovementProvider.stamina(new)
    
    -- If stamina reaches 0 then stop sprinting
    if new <= 0 then
      MovementProvider:setSprint(false)
      MovementProvider:setSprintCooldown(true)
    end
  elseif stamina < MAX_STAMINA then -- Avoid unecessary setting of stamina
    local new = math.min(MAX_STAMINA, stamina + (STAMINA_REGEN_RATE * delta))
    MovementProvider.stamina(new)
  else
    
  end
end

--[[
  Sets the sprinting state to enabled or disabled
]]
function MovementProvider.setSprint (self: self, isSprinting: boolean): ()
  if not self.humanoid then return end
  self.isSprinting = isSprinting

  local walkspeed = isSprinting and constants.WALKSPEED.SPRINTING or constants.WALKSPEED.DEFAULT
  local fov = isSprinting and constants.FOV.SPRINTING or constants.FOV.DEFAULT

  local tween = TweenService:Create(workspace.CurrentCamera, TweenInfo.new(0.1), {
    FieldOfView = fov
  })

  tween:Play()
  tween.Completed:Once(function() tween:Destroy() end)

  self.humanoid.WalkSpeed = walkspeed
end

--[[
  Enables/disables sprint cooldowns
]]
function MovementProvider.setSprintCooldown(self: self, cooldown: boolean): ()
  if cooldown then
    if self.sprintCooldownTimer then return end

    self.sprintCooldownTimer = timer.new(SPRINT_COOLDOWN)
  else
    if not self.sprintCooldownTimer then return end

    self.sprintCooldownTimer:destroy()
    self.sprintCooldownTimer = nil
  end
end

--[[
  Tells us if sprint is on cooldown
]]
function MovementProvider.isSprintOnCooldown(self: self): boolean
  return self.sprintCooldownTimer ~= nil and not self.sprintCooldownTimer:isFinished()
end

--[[
  Attaches listeners for when the character spawns
]]
function MovementProvider._attachToCharacter (self: self): ()
  self.character = self.CharacterProvider:getCharacter()
  self.humanoid = self.CharacterProvider:getHumanoid()

  -- When character is spawned set properties
  self.CharacterProvider.spawned:Connect(function(character, humanoid): ()
    self.character = character
    self.humanoid = humanoid

    self:setSprint(false)
  end)
end

--[[
  Attaches appropriate listeners to input
]]
function MovementProvider._attachInput (self: self): ()
  EzInput.context('player'):action('sprint'):bind(Enum.KeyCode.LeftShift):action():onPressed(function()
    if self:isSprintOnCooldown() then return end -- Do not let the user sprint if sprint on cooldown
    self:setSprint(true)
  end):onReleased(function()
    self:setSprint(false)
  end)
end

export type self = typeof(MovementProvider)
return MovementProvider
