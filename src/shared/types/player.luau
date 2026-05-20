const PLAYER_DATA_TEMPLATE = require('@shared/data/playerDataTemplate')
const cursorIds = require('@shared/data/cursorIds')

const playerTypes = {}

export type PlayerData = typeof(PLAYER_DATA_TEMPLATE)

export type SafePlayerData = PlayerData & {
	anticheatTriggers: never,
}

return playerTypes
