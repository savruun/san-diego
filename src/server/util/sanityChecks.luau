local SanityChecks = {}

function SanityChecks.character(player: Player): boolean
	if not player.Character then
		warn('Player', player.Name, 'does not have a character')
		return false
	end

	local head = player.Character:FindFirstChild('Head')
	if not head then
		warn('Player', player.Name, 'character does not have a head')
		return false
	end

	return true
end

function SanityChecks.tool(player: Player, toolName: string): boolean
	local backpack = player:FindFirstChildOfClass('Backpack')
	if not backpack then
		warn('Player', player.Name, 'does not have a backpack')
		return false
	end

	local tool = backpack:FindFirstChild(toolName)
	if not tool then
		warn('Player', player.Name, 'does not have tool', toolName, 'in backpack')
		return false
	end

	return true
end

return SanityChecks
