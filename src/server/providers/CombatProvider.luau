const Dependency = require("@pkg/quill_dependencies")
const Net = require("@server/net")

type WeaponStateMap = {
  [number]: {
    mode: string,
    ammo: { current: number, max: number }
  }
}

const CombatProvider = {
  PlayerDataProvider = Dependency.use(require("@ssingletons/PlayerDataProvider")),
  weaponState = {} :: WeaponStateMap
}

function CombatProvider.start(self: self)
  Net.FireGun.On(function(player, data)
    self:gunFired(player, data)
  end)
end

function CombatProvider.gunFired(self: self, player: Player, data: Net.GunFireData)
  print("gun fire recieved")
end

export type self = typeof(CombatProvider)
return CombatProvider