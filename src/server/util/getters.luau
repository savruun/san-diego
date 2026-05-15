local Getters = {}

function Getters.getToolFromPlayer(player: Player, toolName: string): Tool?
	local tool = player.Backpack:FindFirstChild(toolName) or player.Character:FindFirstChild(toolName)

	if not tool then
		warn('Player', player.Name, 'does not have tool', toolName)
		return nil
	end

	return tool :: Tool
end

return Getters
