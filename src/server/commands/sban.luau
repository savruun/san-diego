local Players = game:GetService("Players")
const conch = require('@pkg/conch')

local banned: { [number]: string } = {}

Players.PlayerAdded:Connect(function(player)
  local reason = banned[player.UserId]
  if not reason then return end

  player:Kick(reason)
end)

const SbanCommand = conch.register('sban', {
  description = 'Bans a Player from the current server',
  permissions = { 'use_sban' },

  arguments = function()
		return conch.args.player('player', 'The player to kick.'),
			conch.args.optional(conch.args.string('reason', 'The reason for banning the player.'))
	end,

  callback = function(player: Player, reason: string?)
    local banReason = reason or 'You have been banned from this server by a Game Moderator'

    banned[player.UserId] = banReason
    player:Kick(banReason)
  end
})

return SbanCommand