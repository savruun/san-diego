const Players = game:GetService('Players')
const Conch = require('@pkg/conch')

const BanCommand = Conch.register('ban', {
	description = 'Bans a player from the game',
	permissions = { 'use_ban' },

	arguments = function()
		return Conch.args.player('player', 'The player to kick.'),
			Conch.args.opt(Conch.args.string('reason', 'The reason for banning the player.'))
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
