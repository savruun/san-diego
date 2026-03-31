local Players = game:GetService('Players')

function for_each_player(callback: (Player) -> ())
	for _, player in Players:GetPlayers() do
		callback(player)
	end

	Players.PlayerAdded:Connect(callback)
end

return for_each_player
