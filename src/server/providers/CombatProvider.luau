--!strict

const Players = game:GetService('Players')
const RunService = game:GetService('RunService')

const Dependency = require('@pkg/quill_dependencies')
const Net = require('@server/net')

const gunData = require('@shared/data/gunData')
const getters = require('@server/util/getters')
const constants = require('@shared/constants')

const logger = require('@server/logger')

type Gun = keyof<typeof(gunData.data)>

type WeaponStateMap = {
  [number]: {
    [Tool]: {
      gunType: Gun,
      mode: gunData.GunFireMode,
      ammo: { current: number, max: number },
      lastFired: number
    }
  }
}

type GunFireData = {
  ammo: number,
  timestamp: number,
  gunType: string,
  origin: Vector3,
  direction: Vector3
}

const defaultGunData = gunData.default()

-- The max distance in studs in which the player can fire away from themselves (20 should account for latency)
const MAX_DISTANCE_DIFF = 20
const GRAVITY = constants.GRAVITY
const MAX_TRAVELED_DISTANCE = 10000
const FIRE_RATE_EPSILON = 0.01

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

const CombatProvider = {
  PlayerDataProvider = Dependency.use(require('@ssingletons/PlayerDataProvider')),
  weaponState = {} :: WeaponStateMap
}

function CombatProvider.start(self: self)
  Net.FireGun.On(function(player, data)
    self:gunFired(player, data)
  end)

  Net.ReloadGun.On(function(player, data)
    self:gunReload(player, data)
  end)

  self.PlayerDataProvider.DropPlayerData:Connect(function(player)
    self.weaponState[player.UserId] = nil
  end)

  self.PlayerDataProvider.InitializePlayerData:Connect(function(player, _dataAtom)
    self.weaponState[player.UserId] = {}
  end)

  Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(_character)
      self:clearPlayerStateData(player)
    end)
  end)
end

function CombatProvider.gunFired(self: self, player: Player, data: Net.GunFireData): ()
  const character = player.Character
  if not character then return end
  
  const head = character:FindFirstChild('Head') :: BasePart
  if not head then return end

  const distance = (head.Position - data.origin).Magnitude
  if distance > MAX_DISTANCE_DIFF then
    logger:warn(`{player.Name} tried firing from a location {distance} studs away`)
    return
  end
  
  const gunStats = gunData.getDataFromName(data.gunType)
  if not gunStats then return end

  -- Get the gun instance from the character or backpack
  const gun = getters.getToolFromPlayer(player, data.gunType)
  if not gun then return end

  const tip = gun:FindFirstChild('Tip', true)
  if not tip then return end

  const playerWeaponState = self.weaponState[player.UserId]
  if not playerWeaponState then return end

  local gunState = playerWeaponState[gun]

  if gunState == nil then
    self:registerPlayerGun(player, data.gunType, gun)
    gunState = playerWeaponState[gun]
  end

  if gunState.ammo.current <= 0 then
    logger:warn(`Player {player.Name} attempted to fire {data.gunType} without ammo.`)
    return
  end

  const now = os.clock()

  -- Subtract fire rate by epsilon to fix floating point precision error with event frame timing
  if now - gunState.lastFired < gunStats.fireRate - FIRE_RATE_EPSILON  then
    logger:warn(`Player {player.Name} attempted to exceed weapon fire rate.`)
    return
  end

  const mode = gunData.normalizeMode(gunStats.modes[gunState.mode])
  if not mode then return end

  local shots = math.min(mode.shots, gunState.ammo.current)

  -- If the ammo is lower than the amount to burst (if applicable), only fire the amount in the gun
  gunState.ammo.current = math.max(gunState.ammo.current - shots, 0)

  
  -- Set the timestamp for when the user last fired for fireRate purposes
  gunState.lastFired = now

  for i = 1, shots do
    const direction = data.directions[i]
    
    if not direction then
      logger:warn(`Missing direction at index {i}`)
      continue
    end

    -- Run the bullet simulation for damage and whatnot`
    self:bulletSimulation(player, {
      ammo = data.ammo,
      direction = direction,
      gunType = data.gunType,
      origin = data.origin,
      timestamp = data.timestamp
    }, gunStats)

    -- Avoid waiting on the final shot of the burst
    if i < shots and mode.interval then
      task.wait(mode.interval)
    end
  end

  -- If the ammo has a desync then resync it with the client
  if data.ammo ~= gunState.ammo.current then
    Net.SyncGunState.Fire(player, {
      ammo = gunState.ammo.current,
      mode = gunState.mode,
      instance = gun
    })
  end

  -- print('gun fire recieved', data)
  -- print(playerWeaponState)

  -- Render the bullet on every client except the casting
  Net.RenderBullet.FireExcept(player, {
    origin = tip,
    position = data.origin,
    directions = data.directions,
    mode = gunState.mode,
    gunType = data.gunType
  })
end

function CombatProvider.bulletSimulation(self: self, player: Player, data: GunFireData, weaponData: gunData.GunData)
  local position = data.origin
  local velocity = data.direction * weaponData.bulletVelocity
  local traveledDistance = 0

  local connection: RBXScriptConnection
  connection = RunService.Heartbeat:Connect(function(delta)
    local nextPosition = position + velocity * delta
		local displacement = nextPosition - position

    traveledDistance += displacement.Magnitude

    if traveledDistance > MAX_TRAVELED_DISTANCE then
      connection:Disconnect()
      return
    elseif traveledDistance >= weaponData.range then
      velocity += GRAVITY * delta
    end

    raycastParams.ExcludeInstances = { player.Character :: Model }

    local result = workspace:Raycast(position, displacement, raycastParams)
    print('rc', result)

    if result then
      const character = result.Instance:FindFirstAncestorOfClass('Model')
      const humanoid = character and character:FindFirstChildOfClass('Humanoid')

      if humanoid then
        humanoid:TakeDamage(weaponData.damage)
      end

      connection:Disconnect()
      return
    end

    position = nextPosition
  end)
end

function CombatProvider.gunReload(self: self, player: Player, data: Net.GunState): ()
  const character = player.Character
  if not character then return end
  
  const gun = getters.getToolFromPlayer(player, data.instance.Name)
  if not gun then return end

  local playerWeaponState = self.weaponState[player.UserId]
  if not playerWeaponState then return end

  local gunState = playerWeaponState[gun]
  if not gunState then return end

  gunState.ammo.current = gunState.ammo.max

  print('Successfully reloaded gun for player', player.Name)
end

function CombatProvider.registerPlayerGun(self: self, player: Player, gunType: Gun, gunInstance: Tool): ()
  local state = self.weaponState[player.UserId]
  local gunData = gunData.getDataFromName(gunType)

  if not state or not gunData then
    return
  end

  state[gunInstance] = {
    gunType = gunType,
    mode = gunData.defaultMode,
    ammo = {
      current = gunData.ammoCapacity,
      max = gunData.ammoCapacity
    },
    lastFired = 0
  }
end

function CombatProvider.clearPlayerStateData(self: self, player: Player): ()
  self.weaponState[player.UserId] = {}
end

export type self = typeof(CombatProvider)
return CombatProvider
