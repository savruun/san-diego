const anticheatTypes = require('@types/anticheat')
const cursorIds = require('./cursorIds')

const PLAYER_DATA_TEMPLATE = {
	cash = 0,

	temporaryPerks = {} :: { [string]: number },
	hotbar = {} :: { [string]: string },
	anticheatTriggers = {} :: { anticheatTypes.PersistentAnticheatTrigger },

	jailData = {
		jailed = false,
		timeLeft = 0,
		reason = '',
		jailedBy = '',
	},

	settings = {
		teamkillToggleKey = nil :: Enum.KeyCode?,
		enableSpecialLogs = false :: boolean,
		cursor = 'Default' :: keyof<typeof(cursorIds)>,
	},
}

return PLAYER_DATA_TEMPLATE
