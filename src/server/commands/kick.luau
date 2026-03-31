local conch = require('@packages/conch')

local kick_command = conch.register('kick', {
	description = 'Kicks a player from the server',
	permissions = { 'use_kick' },

	arguments = function()
		return conch.args.player('player', 'The player to kick.'),
			conch.args.optional(conch.args.string('reason', 'The reason for kicking the player.'))
	end,

	callback = function(player: Player, reason: string?)
		player:Kick(reason or 'You have been kicked by a game moderator.')
	end,
})

return kick_command
