--!strict

const HttpService = game:GetService('HttpService')
const Dependency = require('@pkg/quill_dependencies')

const anticheatTypes = require('@types/anticheat')
const dictUtility = require('@lib/dictUtility')

const logger = require('@server/logger')

-- A month in seconds
const PERSISTENT_TRIGGER_EXPIRATION = 60 * 60 * 24 * 31
const MAX_TEMPORARY_INCIDENTS = 10

const AnticheatProvider = {
	triggers = {} :: { [number]: { [string]: anticheatTypes.AnticheatTrigger } },
}

AnticheatProvider.PlayerDataProvider = Dependency.use(require('@ssingletons/player/PlayerDataProvider'))

function AnticheatProvider.start(self: self): ()
	self.PlayerDataProvider.DropPlayerData:Connect(function(player) self.triggers[player.UserId] = nil end)

	self.PlayerDataProvider.InitializePlayerData:Connect(function(player, data)
		local currentData = data()
		const now = os.time()

		-- Prune all anticheat incidents that are over the expiration time
		for index, incident in currentData.anticheatTriggers do
			if now - incident.timestamp > PERSISTENT_TRIGGER_EXPIRATION then
				table.remove(currentData.anticheatTriggers, index)
			end
		end

		-- Update the persistent data
		data(currentData)
	end)
end

function AnticheatProvider.addPlayerTrigger(self: self, player: Player, trigger: anticheatTypes.AnticheatTrigger): ()
	local playerTriggers = self.triggers[player.UserId]

	-- Lazy trigger initialization
	if not playerTriggers then
		self.triggers[player.UserId] = {}
		playerTriggers = self.triggers[player.UserId]
	end

	-- Generate a unique id for the trigger
	local uuid = HttpService:GenerateGUID()

	-- Set the trigger in the hashmap
	playerTriggers[uuid] = trigger

	-- Delete the trigger after its alotted life time
	task.delay(trigger.expiration, function() self:removePlayerTrigger(player, uuid) end)

	local playerData = self.PlayerDataProvider:getDataAtom(player)
	if not playerData then return end -- Shouldn't happen in theory

	local currentData = playerData()
	local incidentData = AnticheatProvider:createPersistentIncident(trigger.reason)

	-- Add the incident to their persistent data
	table.insert(currentData.anticheatTriggers, incidentData)

	-- Save the data ammendment in their persistent data
	playerData(currentData)

	-- If the player has surpassed the max number of temporary incidents then kick
	if dictUtility.size(playerTriggers) >= MAX_TEMPORARY_INCIDENTS then
		player:Kick(`[Anticheat]: Triggered {MAX_TEMPORARY_INCIDENTS} anticheat incidents within a short time-span.`)
		logger:info(`Kicked {player.Name} for surpassing {MAX_TEMPORARY_INCIDENTS} triggers.`)
	end
end

function AnticheatProvider.removePlayerTrigger(self: self, player: Player, uuid: string): ()
	local playerTriggers = self.triggers[player.UserId]
	if not playerTriggers then return end

	playerTriggers[uuid] = nil
end

function AnticheatProvider.createPersistentIncident(
	self: self,
	reason: string,
	uuid: string?
): anticheatTypes.PersistentAnticheatTrigger
	return {
		timestamp = os.time(),
		incidentId = uuid or HttpService:GenerateGUID(),
		reason = reason,
	}
end

export type self = typeof(AnticheatProvider)
return AnticheatProvider
