const Players = game:GetService('Players')

const Charm = require('@pkg/charm')
const ProfileStore = require('@spkg/profilestore')

const Signal = require('@shared/lib/Signal')
const PLAYER_DATA_TEMPLATE = require('@shared/lib/data/playerDataTemplate')
const PlayerUtility = require('@shared/lib/playerUtility')

const metadata = require('@server/meta')
local playerMeta = metadata.players

const playerStore = ProfileStore.New('PlayerData', PLAYER_DATA_TEMPLATE :: any)
type Profile = typeof(playerStore:StartSessionAsync('0', {}))

local profiles: { [number]: Profile } = {}
local cleanups: { [number]: () -> () } = {}

const PlayerDataProvider = {
	DropPlayerData = Signal.new<<(Player)>>(),
	InitializePlayerData = Signal.new<<(Player, Charm.Atom<typeof(PLAYER_DATA_TEMPLATE)>)>>()
}

function PlayerDataProvider.start(self: self)
	PlayerUtility:forEachPlayer(function(player: Player)
		self:playerAdded(player)
	end)

	Players.PlayerRemoving:Connect(function(player: Player, exitReason: Enum.PlayerExitReason)
		self:playerRemoving(player, exitReason)
	end)
end

function PlayerDataProvider.getProfile(self: self, player: Player): Profile?
	return profiles[player.UserId]
end

function PlayerDataProvider.getData(self: self, player: Player)
	local profile = self:getProfile(player)
	return profile and profile.Data
end

function PlayerDataProvider.createPlayerProfile(self: self, player: Player)
	local profile = playerStore:StartSessionAsync(`{player.UserId}`, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	if not profile then
		player:Kick('Profile failed to load. Please rejoin.')
		return
	end

	profile:AddUserId(player.UserId)
	profile:Reconcile()

	profile.OnSessionEnd:Connect(function()
		profiles[player.UserId] = nil

		if player.Parent == Players then
			player:Kick('Profile session ended. Please rejoin.')
		end
	end)

	if player.Parent == Players then
		profiles[player.UserId] = profile
	else
		profile:EndSession()
	end
end

function PlayerDataProvider.playerAdded(self: self, player: Player)
	self:createPlayerProfile(player)

	local profile = profiles[player.UserId]
	if not profile then
		return
	end

	local dataAtom = Charm.atom<<typeof(PLAYER_DATA_TEMPLATE)>>(profile.Data)

	playerMeta[player.UserId] = {
		data = dataAtom,
	}

	cleanups[player.UserId] = Charm.subscribe(dataAtom, function(data)
		profile.Data = data
	end)

	-- Fire to all subscribers that player data should be initialized
	self.InitializePlayerData:Fire(player, dataAtom)
end

function PlayerDataProvider.playerRemoving(
	self: self,
	player: Player,
	_exitReason: Enum.PlayerExitReason
)
	local userId = player.UserId

	local profile = profiles[userId]
	if not profile then return end

	local cleanup = cleanups[userId]

	if cleanup ~= nil then
		cleanup()
		cleanups[userId] = nil
	end

	self.dropPlayerData:Fire(player)

	profile:EndSession()
	profiles[userId] = nil
	playerMeta[userId] = nil
end

export type self = typeof(PlayerDataProvider)
return PlayerDataProvider
