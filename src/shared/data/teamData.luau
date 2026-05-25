const TeamEnum = require('@enums/Team')
const SafeChatGroupEnum = require('@enums/SafeChatGroup')

export type TeamData = {
	name: string,
	safeChatGroup: string,
	acronym: string?,
	maxPlayers: number?,
	color: Color3,
	loadout: { string },
}

const teamData: { [string]: TeamData } = {
	[TeamEnum.FBI] = {
		name = 'Federal Bureau of Investigation',
		acronym = 'FBI',
		maxPlayers = 10,
		safeChatGroup = SafeChatGroupEnum.Armed,
		color = Color3.new(),
		loadout = {},
	},

	[TeamEnum.HLS] = {
		name = 'Homeland Security',
		acronym = 'HLS',
		maxPlayers = 3,
		safeChatGroup = SafeChatGroupEnum.Armed,
		color = Color3.new(0, 0.443137, 0.780392),
		loadout = {},
	},

	[TeamEnum.USBP] = {
		name = 'Border Patrol',
		acronym = 'US:BP',
		maxPlayers = 10,
		safeChatGroup = SafeChatGroupEnum.Armed,
		color = Color3.new(0.196078, 0.298039, 0.156863),
		loadout = {},
	},

	[TeamEnum.Civilian] = {
		name = 'Civilians',
		safeChatGroup = SafeChatGroupEnum.Unarmed,
		color = Color3.new(0.764706, 1, 0.807843),
		loadout = {},
	},
}

return teamData
