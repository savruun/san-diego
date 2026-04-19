--!strict

const TweenService = game:GetService('TweenService')
const ezinput = require('@pkg/ezinput')
const charm = require('@pkg/charm')

const dependency = require('@pkg/quill_dependencies')
const constants = require('@shared/constants')


const MAX_STAMINA = 100
const STAMINA_DRAIN_RATE = 15 -- % per sec
const STAMINA_REGEN_RATE = 10 -- % per sec

const MovementProvider = {
  isSprinting = false, stamina = charm.atom(100),

  character = nil :: Model?,
  humanoid = nil :: Humanoid?
}

MovementProvider.CharacterProvider = dependency.use(require('./CharacterProvider'))

function MovementProvider.start (self: self): ()
  self:_attachToCharacter()
  self:_attachInput()
end

function MovementProvider.on_heartbeat(delta: number): ()
  if not MovementProvider.isSprinting then return end

  local currentStamina = MovementProvider.stamina()
  MovementProvider.stamina(currentStamina - (1 * delta))
end

function MovementProvider.setSprint (self: self, isSprinting: boolean): ()
  if not self.humanoid then return end
  self.isSprinting = isSprinting

  local walkspeed = isSprinting and constants.walkspeed.sprinting or constants.walkspeed.default
  local fov = isSprinting and constants.fov.sprinting or constants.fov.default

  local tween = TweenService:Create(workspace.CurrentCamera, TweenInfo.new(0.1), {
    FieldOfView = fov
  })

  tween:Play()
  tween.Completed:Once(function() tween:Destroy() end)

  self.humanoid.WalkSpeed = walkspeed
end

function MovementProvider._attachToCharacter (self: self): ()
  self.character = self.CharacterProvider:getCharacter()
  self.humanoid = self.CharacterProvider:getHumanoid()

  self.CharacterProvider.spawned:Connect(function(character, humanoid): ()
    self.character = character
    self.humanoid = humanoid

    self:setSprint(false)
  end)
end

function MovementProvider._attachInput (self: self): ()
  ezinput.context('player'):action('sprint'):bind(Enum.KeyCode.LeftShift):action():onPressed(function() 
    self:setSprint(true)
  end):onReleased(function()
    self:setSprint(false)
  end)
end

export type self = typeof(MovementProvider)
return MovementProvider
