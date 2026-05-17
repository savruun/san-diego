const Players = game:GetService('Players')
const RunService = game:GetService('RunService')
const UserInputService = game:GetService('UserInputService')

const vide = require('@pkg/vide')
const create = vide.create
const source = vide.source
const spring = vide.spring
const values = vide.values
const cleanup = vide.cleanup
const effect = vide.effect

const abbreviateNumber = require('@ui/util/abbreviateNumber')
const gunData = require('@shared/data/gunData')

const Card = require('@ui/components/Card')
const GradientButton = require('@ui/components/GradientButton')
const ProgressBar = require('@ui/components/ProgressBar')
const Label = require('@ui/components/Label')
const Row = require('@ui/components/Row')

const CombatProvider = require('@csingletons/combat/CombatProvider')

const meta = require('@client/meta')
const iconIds = require('@shared/data/iconIds')

const useAtom = require('@ui/hooks/useAtom')
const atoms = require('@shared/atoms')

const Player = Players.LocalPlayer
const mouse = Player:GetMouse()

type SideButtonProps = {
	text: string,
	image: string?,
}

const DEFAULT_SIDE_BUTTON_SIZE = 0.37
const HOVER_SIDE_BUTTON_SIZE = 0.4

local function GunInfo()
	const gunName = useAtom(atoms.gun.name)
	const ammo = useAtom(atoms.gun.ammo)
	const mode = useAtom(atoms.gun.mode)

	const modes = source<<{ string }>>({})

	vide.effect(function()
		const weaponData = gunData.getDataFromName(gunName())
		if not weaponData then return end

		local newModes = {} :: { string }

		for mode, _ in weaponData.modes or {} do
			table.insert(newModes, mode)
		end

		modes(newModes)
	end)

	return Card {
		name = 'GunInfo',
		size = UDim2.fromScale(0.15, 0.1),
		position = UDim2.fromScale(1, 0.99),
		anchorPoint = Vector2.new(1, 1),

		transparency = 0.4,

		create 'UIAspectRatioConstraint' {
			AspectRatio = 3.5,
		},

		create 'UISizeConstraint' {
			MaxSize = Vector2.new(225, 225),
		},

		create 'TextLabel' {
			Name = 'GunName',

			Position = UDim2.fromScale(0.05, 0.1),
			Size = UDim2.fromScale(0.8, 0.25),

			BackgroundTransparency = 1,

			Text = gunName,

			TextXAlignment = Enum.TextXAlignment.Left,
			Font = Enum.Font.ArimoBold,
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
		},

		Row {
			align = Enum.HorizontalAlignment.Center,
			position = UDim2.fromScale(0.5, 0.4),
			size = UDim2.fromScale(1, 0.2),
			anchor = Vector2.new(0.5),
			padding = UDim.new(0.05),

			values(modes, function(name)
				const gunType = gunName()
				const weaponData = gunData.getDataFromName(gunType)

				return Label {
					text = string.upper(name),
					button = true,
					font = Enum.Font.ArimoBold,
					order = name ~= weaponData.defaultMode and 1 or nil,

					color = function() return mode() == name and Color3.new(1, 1, 1) or Color3.new(0.498039, 0.498039, 0.498039) end,

					scaled = true,
					size = UDim2.fromScale(0.2, 1),
				}
			end),
		},

		ProgressBar {
			name = 'Ammo',
			position = UDim2.fromScale(0.5, 0.75),
			size = UDim2.fromScale(0.9, 0.2),
			anchor = Vector2.new(0.5),
		},
	}
end

local function SideButton(props: SideButtonProps)
	local size = source(0.37)
	local sizeSpring = spring(size, 0.3)

	return create 'TextButton' {
		BackgroundColor3 = Color3.new(),
		BackgroundTransparency = 0.4,

		Size = function()
			local currentSize = sizeSpring()
			return UDim2.fromScale(currentSize, currentSize)
		end,

		MouseEnter = function() size(HOVER_SIDE_BUTTON_SIZE) end,

		MouseLeave = function() size(DEFAULT_SIDE_BUTTON_SIZE) end,

		create 'UIAspectRatioConstraint' {
			AspectRatio = 1,
		},

		create 'UICorner' {
			CornerRadius = UDim.new(0.1),
		},

		create 'UIStroke' {
			Color = Color3.new(0.615686, 0.615686, 0.615686),
			Thickness = 2,
			Transparency = 0.35,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		},

		create 'TextLabel' {
			Text = props.text,
			Font = Enum.Font.ArialBold,
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
			Size = UDim2.fromScale(1, 0.25),
			Position = UDim2.fromScale(0.5, 0.97),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,

			create 'UIStroke' {
				Thickness = 1,
			},
		},

		create 'ImageLabel' {
			Size = UDim2.fromScale(0.7, 0.7),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = props.image or 'rbxassetid://3926305904',
		},
	}
end

local function HUD()
	const data = useAtom(meta.playerData)
	const mousePos = source(Vector2.new(mouse.X, mouse.Y))
	const hitmarker = source(false)

	local mouseConn = RunService.RenderStepped:Connect(function()
		local mouseLoc = UserInputService:GetMouseLocation()
		mousePos(mouseLoc)
	end)

	local hitPersonConn = CombatProvider.HitEnemy:Connect(function() hitmarker(true) end)

	cleanup(function()
		mouseConn:Disconnect()
		hitPersonConn:Disconnect()
	end)

	effect(function()
		const hm = hitmarker()
		if not hm then return end

		task.delay(0.25, function() hitmarker(false) end)
	end)

	return create 'Frame' {
		Name = 'HUD',
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,

		create 'UIPadding' {
			PaddingRight = UDim.new(0, 5),
			PaddingTop = UDim.new(0, 5),
		},

		-- SIDEBAR
		Card {
			name = 'Sidebar',
			size = UDim2.fromScale(0.25, 0.45),
			position = UDim2.fromScale(1, 0.5),
			anchorPoint = Vector2.new(1, 0.5),
			transparency = 1,
			strokeTransparency = 1,

			create 'UIAspectRatioConstraint' {
				AspectRatio = 0.55,
			},

			create 'UISizeConstraint' {
				MaxSize = Vector2.new(300, 300),
			},

			create 'UIListLayout' {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0.03),
			},

			SideButton {
				text = 'Shop',
				image = iconIds.hud.shop,
			},

			SideButton {
				text = 'Teams',
				image = iconIds.hud.teams,
			},
		},

		-- TOP RIGHT CURRENCY BAR
		Card {
			name = 'CurrencyBar',
			size = UDim2.fromScale(0.2, 0.2),
			position = UDim2.fromScale(1, 0),
			anchorPoint = Vector2.new(1, 0),
			color = Color3.new(),
			transparency = 0.4,

			create 'UIAspectRatioConstraint' {
				AspectRatio = 4,
			},

			create 'UISizeConstraint' {
				MaxSize = Vector2.new(200, 200),
			},

			create 'UIListLayout' {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0.05),
			},

			create 'UIPadding' {
				PaddingLeft = UDim.new(0.05),
			},

			create 'ImageLabel' {
				Image = iconIds.hud.money,
				Size = UDim2.fromScale(0.3, 0.8),
				BackgroundTransparency = 1,

				create 'UIAspectRatioConstraint' {
					AspectRatio = 1,
				},
			},

			create 'TextLabel' {
				Text = function()
					const currentData = data() or { cash = 0 }
					return `$ {abbreviateNumber(currentData.cash)}`
				end,

				Font = Enum.Font.ArimoBold,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.fromScale(0, 0.5),
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0.5, 0.5),
				TextColor3 = Color3.new(0.223529, 0.788235, 0.533333),
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Left,
			},

			GradientButton {
				text = '+',
				font = Enum.Font.ArimoBold,
				size = UDim2.fromScale(0.4, 0.4),
				textScaled = true,
				cornerRadius = UDim.new(0.2),
				backgroundColor = ColorSequence.new(Color3.new(1, 0.913725, 0.14902), Color3.new(1, 0.627451, 0.137255)),
				color = Color3.new(1, 1, 1),
				strokeColor = Color3.new(1, 0.705882, 0.078431),
				strokeWidth = 2,
			},
		},

		GunInfo(),

		create 'ImageLabel' {
			Name = 'Hitmarker',
			Image = iconIds.hitmarker,
			Size = UDim2.fromScale(0.03, 0.03),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Visible = hitmarker,

			Position = function()
				const currentMouse = mousePos()
				return UDim2.fromOffset(currentMouse.X, currentMouse.Y)
			end,

			create 'UIAspectRatioConstraint' {
				AspectRatio = 1,
			},
		},
	}
end

return HUD
