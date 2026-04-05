const Players = game:GetService('Players')
const conch = require('@pkg/conch')

const BanCommand = conch.register('ban', {
	description = 'Bans a player from the server',
	permissions = { 'use_ban' },

	arguments = function()
		return conch.args.player('player', 'The player to kick.'),
			conch.args.optional(conch.args.string('reason', 'The reason for banning the player.'))
	end,

	callback = function(player: Player, reason: string?)
		Players:BanAsync({
			UserIds = { player.UserId },
			ApplyToUniverse = true,
			Duration = -1,
			DisplayReason = reason or 'You have been banned by a game moderator.',
		})
	end,
})

return BanCommand
