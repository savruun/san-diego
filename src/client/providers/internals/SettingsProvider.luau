const charm = require('@pkg/charm')
const atoms = require('@shared/atoms')

const playerTypes = require('@types/player')
const Signal = require('@shared/lib/Signal')

const SettingsProvider = {
	--[[
    Fires when a setting changes.
	]]
	SettingChanged = Signal.new<<(string, any, any)>>(),
}

function SettingsProvider.start(self: self)
	charm.subscribe(atoms.playerData, function(state, lastState)
		for name: string, value in state do
			const lastValue = lastState[name]
			if value == lastValue then continue end -- If theres no diff then skip it

			self.SettingChanged:Fire(name, value)
		end
	end)
end

--[[
  Get all player settings.
]]
function SettingsProvider.getSettings(self: self): playerTypes.SafePlayerData return atoms.playerData() end

--[[
  Get a setting's value by its name.
  @param settingName The name of the setting to get.
]]
function SettingsProvider.getSetting(self: self, settingName: keyof<playerTypes.SafePlayerData>)
	const settings = atoms.playerData()
	return settings[settingName]
end

export type self = typeof(SettingsProvider)
return SettingsProvider
