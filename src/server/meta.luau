const charm = require('@pkg/charm')
const playerTypes = require('@types/player')

type MetaData = {
  players: { [number]: { data: charm.Atom<playerTypes.PlayerData> } },
  server: {}
}

const metadata: MetaData = {
  players = {},
  server = {}
}

return metadata
