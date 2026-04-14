const Players = game:GetService('Players')
const charm = require('@pkg/charm')

const profilestore = require('@spkg/profilestore')
const PLAYER_DATA_TEMPLATE = require('@shared/lib/data/playerDataTemplate')
const playerUtility = require('@shared/lib/playerUtility')

const metadata = require('@server/meta')
local playerMeta = metadata.players

const playerStore = profilestore.New('PlayerData', PLAYER_DATA_TEMPLATE)
local profiles: { [Player]: typeof(playerStore:StartSessionAsync()) } = {}
local cleanups: { [number]: () -> () } = {}

const PlayerDataProvider = {}

function PlayerDataProvider.start(self: self)
  playerUtility:forEachPlayer(function(player: Player)
    self:playerAdded(player)
  end)

  Players.PlayerRemoving:Connect(function(player, exitReason)
    self:playerRemoving(player, exitReason)
  end)
end

function PlayerDataProvider.getProfile(self: self, player: Player)
  return profiles[player.UserId]  
end

function PlayerDataProvider.getData(self: self, player: Player)
  return self:getProfile(player).Data
end

function PlayerDataProvider.createPlayerProfile(self: self, player: Player)
  const profile = playerStore:StartSessionAsync(`{player.UserId}`, {
    Cancel = function()
      return player.Parent ~= Players
    end
  })

  if profile ~= nil then
    profile:AddUserId(player.UserId)
    profile:Reconcile()

    profile.OnSessionEnd:Connect(function()
      profiles[player.UserId] = nil
      player:Kick('Profile session end - please rejoin.')
    end)

    if player.Parent == Players then
      profiles[player] = profile
      print(profiles[player.UserId])
    else
      profile:EndSession()
    end
  else
    player:Kick('Profile load fail - please rejoin.')
  end
end

function PlayerDataProvider.playerAdded(self: self, player: Player)
  self:createPlayerProfile(player)

  local dataAtom = charm.atom(profiles[player.UserId].Data)

  playerMeta[player.UserId] = {}
  playerMeta[player.UserId].data = dataAtom

  cleanups[player.UserId] = charm.subscribe(dataAtom, function(data)
    profiles[player.UserId] = data
  end)
end

function PlayerDataProvider.playerRemoving(self: self, player: Player, exitReason: Enum.PlayerExitReason)
  const profile = profiles[player]
  if not profile then return end

  profile:EndSession()
  profiles[player.UserId] = nil
  
  local cleanup = cleanups[player.UserId]
  if cleanup then cleanup() end
end

export type self = typeof(PlayerDataProvider)
return PlayerDataProvider