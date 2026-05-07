--!strict

const Players = game:GetService('Players')

const Dependency = require('@pkg/quill_dependencies')
const Net = require('@server/net')

const GunData = require('@shared/lib/data/gunData')

type Gun = keyof<typeof(GunData.data)>

type WeaponStateMap = {
  [number]: {
    [Tool]: {
      gunType: Gun,
      mode: string,
      ammo: { current: number, max: number }
    }
  }
}

const CombatProvider = {
  PlayerDataProvider = Dependency.use(require('@ssingletons/PlayerDataProvider')),
  weaponState = {} :: WeaponStateMap
}

function CombatProvider.start(self: self)
  Net.FireGun.On(function(player, data)
    self:gunFired(player, data)
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

function CombatProvider.gunFired(self: self, player: Player, data: Net.GunFireData)
  local character = player.Character
  if not character then return end
  
  local head = character:FindFirstChild('Head')
  if not head then return end

  local gunData = GunData.getDataFromName(data.gunType)
  if not gunData then return end

  -- Get the gun instance from the character or backpack
  local gun = character:FindFirstChild(data.gunType) or player.Backpack:FindFirstChild(data.gunType)
  if not gun then return end

  -- Immediately run a request to all clients to render the bullet for responsiveness
  Net.RenderBullet.FireExcept(player, {
    position = data.origin,
    origin = data.origin,
    velocity = gunData.bulletVelocity,
    direction = data.direction
  })
  
  print('gun fire recieved', data)
end

function CombatProvider.registerPlayerGun(self: self, player: Player, gunType: Gun, gunInstance: Tool)
  local state = self.weaponState[player.UserId]
  local gunData = GunData.getDataFromName(gunType)

  if not state or not gunData then
    return
  end

  state[gunInstance] = {
    gunType = gunType,
    mode = gunData.mode,
    ammo = {
      current = gunData.ammoCapacity,
      max = gunData.ammoCapacity
    }
  }
end

function CombatProvider.clearPlayerStateData(self: self, player: Player)
  self.weaponState[player.UserId] = {}
end

export type self = typeof(CombatProvider)
return CombatProvider