const meta = require('@server/meta')
const playerMeta = meta.players
const _serverMeta = meta.server

const MetaProvider = {}

function MetaProvider.start(self: self)

end

function MetaProvider.getPlayerMeta(self: self, player: Player)
  local meta = playerMeta[player.UserId]

  if not meta then
    playerMeta[player.UserId] = player
    meta = playerMeta[player.UserId]
  end

  return meta
end

function MetaProvider.setPlayerMetaKey(self: self, player: Player, key: string, value: any)
  local meta = self:getPlayerMeta(player)
  meta[key] = value

  return meta
end

export type self = typeof(MetaProvider)
return MetaProvider