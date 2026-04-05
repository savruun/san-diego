const Players = game:GetService('Players')

const function forEachPlayer(callback: (Player) -> ()): RBXScriptConnection
	for _, player in Players:GetPlayers() do
		callback(player)
	end

	return Players.PlayerAdded:Connect(callback)
end

return forEachPlayer
