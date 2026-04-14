const Players = game:GetService('Players')
const player = Players.LocalPlayer

const vide = require('@pkg/vide')
const create = vide.create
const cleanup = vide.cleanup
const source = vide.source

const function Sidebar()
	return create 'Frame' {
		Name = 'Sidebar',
		Size = UDim2.fromScale(1, 1)
	}	
end

const function CharacterSidebarContainer()
	const humanoidRoot = source(nil)

	const characterAddedConnection = player.CharacterAdded:Connect(function(character)
		humanoidRoot(character:WaitForChild('HumanoidRootPart'))
	end)
	
	cleanup(function()
		characterAddedConnection:Disconnect()
	end)
	
	if player.Character then
		humanoidRoot(player.Character:FindFirstChild('HumanoidRootPart'))
	end

	return create 'BillboardGui' {
		Name = 'SidebarContainer',
		Size = UDim2.fromScale(1, 1),
		AlwaysOnTop = true,
		
		Adornee = function()
			return humanoidRoot() :: BasePart?
		end,

		Sidebar()
	}
end

return CharacterSidebarContainer
