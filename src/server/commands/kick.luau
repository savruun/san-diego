const Conch = require('@pkg/conch')

const KickCommand = Conch.register('kick', {
	description = 'Kicks a player from the server',
	permissions = { 'use_kick' },

	arguments = function()
		return Conch.args.player('player', 'The player to kick.'),
			Conch.args.opt(Conch.args.string('reason', 'The reason for kicking the player.'))
	end,

	callback = function(player: Player, reason: string?)
		player:Kick(reason or 'You have been kicked by a game moderator.')
	end,
})

return KickCommand
