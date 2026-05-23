const TeamEnum = require('@enums/Team')
const SafeChatGroupEnum = require('@enums/SafeChatGroup')

const teamData = {
	[TeamEnum.FBI] = {
		Name = 'Federal Bureau of Investigation',
		SafeChatGroup = SafeChatGroupEnum.Armed,
		Color = Color3.new(),
		Loadout = {},
	},

	[TeamEnum.HLS] = {
		Name = 'Homeland Security',
		SafeChatGroup = SafeChatGroupEnum.Armed,
		Color = Color3.new(),
		Loadout = {},
	},

	[TeamEnum.Civilian] = {
		Name = 'Civilians',
		SafeChatGroup = SafeChatGroupEnum.Unarmed,
		Color = Color3.new(),
		Loadout = {},
	},
}

return teamData
