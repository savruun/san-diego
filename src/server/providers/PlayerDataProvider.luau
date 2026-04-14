const Players = game:GetService('Players')
const charm = require('@pkg/charm')

const profilestore = require('@spkg/profilestore')
const PLAYER_DATA_TEMPLATE = require('@shared/lib/data/playerDataTemplate')
const playerUtility = require('@shared/lib/playerUtility')

const metadata = require('@server/meta')
local playerMeta = metadata.players

const playerStore = profilestore.New('PlayerData', PLAYER_DATA_TEMPLATE)
local profiles: { [Player]: typeof(playerStore:StartSessionAsync())} = {}

const PlayerDataProvider = {}

function PlayerDataProvider.start(self: self)
  playerUtility:forEachPlayer(function(player: Player)
    self:playerAdded(player)
  end)

  Players.PlayerRemoving:Connect(function(player, exitReason)
    self:playerRemoving(player, exitReason)
  end)
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
  metadata[player.UserId] = nil -- placeholder til i setup charm which is gonna hold global state
end

function PlayerDataProvider.playerRemoving(self: self, player: Player, exitReason: Enum.PlayerExitReason)
  const profile = profiles[player]
  if not profile then return end

  profile:EndSession()
  profiles[player.UserId] = nil
end

export type self = typeof(PlayerDataProvider)
return PlayerDataProvider