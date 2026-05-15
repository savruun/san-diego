const Players = game:GetService('Players')
const Player = Players.LocalPlayer

const vide = require('@pkg/vide')

const create = vide.create
const cleanup = vide.cleanup
const source = vide.source

const MovementProvider = require('@csingletons/character/MovementProvider')
const useAtom = require('@ui/hooks/useAtom')
const constants = require('@shared/constants')

const MAX_STAMINA = constants.MAX_STAMINA

const function Sidebar(props: { Name: string, Stamina: vide.Source<number> })
	return create 'Frame' {
		Name = 'Sidebar',
		Size = UDim2.fromScale(.15, 1),
		BackgroundColor3 = Color3.new(),
		BackgroundTransparency = .5,
		

		create 'UICorner' {
			CornerRadius = UDim.new(.1)
		},

		create 'Frame' {
			Name = 'Filler',
			
			Size = function()
				return UDim2.fromScale(1, props.Stamina() / 100)
			end,

			Position = UDim2.fromScale(.5, 1),
			AnchorPoint = Vector2.new(.5, 1),

			create 'UIGradient' {
				Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(0.831373, 0.831373, 0.831373)),
				Rotation = 90
			},

			create 'UICorner' {
				CornerRadius = UDim.new(.1)
			}
		}
	}	
end

const function CharacterSidebarContainer()
	local humanoidRoot = source(nil)
	local stamina = useAtom(MovementProvider.stamina)

	local characterAddedConnection = Player.CharacterAdded:Connect(function(character)
		humanoidRoot(character:WaitForChild('HumanoidRootPart'))
	end)
	
	cleanup(function()
		characterAddedConnection:Disconnect()
	end)
	
	if Player.Character then
		humanoidRoot(Player.Character:FindFirstChild('HumanoidRootPart'))
	end

	return create 'BillboardGui' {
		Name = 'SidebarContainer',
		Size = UDim2.fromScale(2, 5),
		AlwaysOnTop = true,
		StudsOffset = Vector3.new(3.5),

		Adornee = function()
			return humanoidRoot() :: BasePart?
		end,

		Enabled = function()
			return stamina() < MAX_STAMINA
		end,


		create 'UIListLayout' {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left
		},

		Sidebar {
			Name = 'StaminaBar',
			Stamina = stamina 
		}
	}
end

return CharacterSidebarContainer
