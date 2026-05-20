

const Players = game:GetService('Players')

const Charm = require('@pkg/charm')
const future = require('@pkg/future')
const ProfileStore = require('@spkg/profilestore')

const Signal = require('@shared/lib/Signal')
const PLAYER_DATA_TEMPLATE = require('@shared/data/playerDataTemplate')
const PlayerUtility = require('@shared/lib/playerUtility')

const net = require('@server/net')
const metadata = require('@server/meta')
const playerTypes = require('@types/player')

local playerMeta = metadata.players

const playerStore = ProfileStore.New('PlayerData', PLAYER_DATA_TEMPLATE :: any)
type Profile = typeof(playerStore:StartSessionAsync('0', {}))

local profiles: { [number]: Profile } = {}
local cleanups: { [number]: () -> () } = {}

-- The max amount of time to yield for a profile in getProfile
const MAX_PROFILE_ELAPSED_WAIT = 3

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

  net.GetPersistentData.On(function(player)
    return self:getSafeData(player)
  end)
end

--[[
  Gets the player's profile asynchronously
]]
function PlayerDataProvider.getProfileAsync(self: self, player: Player): future.Future<Profile?>
  local elapsed = 0
	return future.new(function()
    while not profiles[player.UserId] and elapsed < MAX_PROFILE_ELAPSED_WAIT do
      task.wait(.1)
      elapsed += .1
    end

    return profiles[player.UserId]
	end)
end

--[[
  Gets player data table asynchronously
]]
function PlayerDataProvider.getDataAsync(self: self, player: Player): future.Future<typeof(PLAYER_DATA_TEMPLATE)?>
  return future.new(function()
    const profile = self:getProfileAsync(player):Await()
    if not profile then return end

    return profile.Data
  end)  
end

--[[
  Gets the player's profile synchronously
]]
function PlayerDataProvider.getProfile(self: self, player: Player): Profile?
  local profile = profiles[player.UserId]
  return profile
end

--[[
  Returns the direct player data table
]]
function PlayerDataProvider.getData(self: self, player: Player)
	local profile = self:getProfile(player)
  if not profile then return end

	return profile.Data
end

--[[
  Returns the atom linked to player data
]]
function PlayerDataProvider.getDataAtom(self: self, player: Player): Charm.Atom<typeof(PLAYER_DATA_TEMPLATE)>?
  local meta = playerMeta[player.UserId]
  if not meta then return nil end

  return meta.data
end

--[[
  Returns data safe for client consumption
]]
function PlayerDataProvider.getSafeData(self: self, player: Player): playerTypes.SafePlayerData?
  const data = self:getData(player)
  if not data then return end

  return {
    cash = data.cash,
    jailData = data.jailData,
    hotbar = data.hotbar
  }
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

	cleanups[player.UserId] = Charm.subscribe<<typeof(PLAYER_DATA_TEMPLATE)>>(dataAtom, function(data)
    -- Set the persistent data
		profile.Data = data

    -- Update the client on its safe player data
    net.SyncPlayerData.Fire(player, self:getSafeData(player))
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

	self.DropPlayerData:Fire(player)

	profile:EndSession()
	profiles[userId] = nil
	playerMeta[userId] = nil
end

export type self = typeof(PlayerDataProvider)
return PlayerDataProvider
