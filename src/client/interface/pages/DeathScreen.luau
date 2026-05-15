const vide = require('@pkg/vide')
const create = vide.create

const GradientBanner = require('@ui/components/GradientBanner')
const BackgroundBlur = require('@ui/components/BackgroundBlur')
const BackgroundColorCorrection = require('@ui/components/BackgroundColorCorrection')
const GradientButton = require('@ui/components/GradientButton')
const TextStroke = require('@ui/components/TextStroke')

const Black = Color3.new(0, 0, 0)
const White = Color3.new(1, 1, 1)


local function DeathScreen()
	return create 'Frame' {
		Name = 'DeathScreen',
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,

		GradientBanner {
			position = UDim2.fromScale(0.5, 0.45),
			anchor = Vector2.new(0.5, 0.5),
			size = UDim2.fromScale(1, 0.25),

			color = ColorSequence.new(Color3.new(0.109804, 0, 0)),
			transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.1, 1),
				NumberSequenceKeypoint.new(0.35, 0.25),
				NumberSequenceKeypoint.new(0.65, 0.25),
				NumberSequenceKeypoint.new(0.9, 1),
				NumberSequenceKeypoint.new(1, 1),
			}),

			strokecolor = ColorSequence.new(Black),
			strokewidth = 2,
			stroketransparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.1, 1),
				NumberSequenceKeypoint.new(0.4, 0.2),
				NumberSequenceKeypoint.new(0.6, 0.2),
				NumberSequenceKeypoint.new(0.9, 1),
				NumberSequenceKeypoint.new(1, 1),
			}),

			create 'UISizeConstraint' {
				MinSize = Vector2.new(0, 100),
				MaxSize = Vector2.new(math.huge, 175),
			},

			create 'TextLabel' {
				Size = UDim2.fromScale(1, 0.4),
				Position = UDim2.fromScale(0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),

				Text = 'You Died',
				Font = Enum.Font.ArialBold,
				TextScaled = true,
				TextColor3 = Color3.new(1, 0.176471, 0.176471),
				BackgroundTransparency = 1,

				TextStroke(),
			},

			create 'TextLabel' {
				Size = UDim2.fromScale(1, 0.22),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),

				Text = 'You can do it, savruun!',
				Font = Enum.Font.Arimo,
				TextScaled = true,
				TextColor3 = White,
				BackgroundTransparency = 1,
			},

			create 'TextLabel' {
				Size = UDim2.fromScale(0.7, 0.12),
				Position = UDim2.fromScale(0.5, 0.9),
				AnchorPoint = Vector2.new(0.5, 0.5),

				Text = 'If you\'re getting spawn killed or can\'t get around someone, switch spawns!',
				Font = Enum.Font.Arimo,
				TextScaled = true,
				TextColor3 = Color3.new(0.458824, 0.458824, 0.458824),
				BackgroundTransparency = 1,

				create 'UITextSizeConstraint' {
					MinTextSize = 20,
				},
			},
		},

		create 'Frame' {
			Size = UDim2.fromScale(1, 0.2),
			Position = UDim2.fromScale(0.5, 0.6),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,

			create 'UISizeConstraint' {
				MaxSize = Vector2.new(math.huge, 70),
			},

			create 'UIListLayout' {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 20),
			},

			GradientButton {
				text = 'Respawn',
				textScaled = true,
				aspectRatio = 3,
				font = Enum.Font.ArimoBold,
				color = White,
				size = UDim2.fromScale(0.1, 0.7),
				backgroundColor = ColorSequence.new(Color3.new(0, 0.996078, 0.317647), Color3.new(0, 0.572549, 0.047059)),
				cornerRadius = UDim.new(0.1),
				padding = UDim.new(0.2),
				strokeWidth = 1.5,
				strokeColor = Color3.new(0, 0, 0),
			},

			GradientButton {
				text = 'Main Menu',
				textScaled = true,
				aspectRatio = 3,
				font = Enum.Font.ArimoBold,
				color = White,
				size = UDim2.fromScale(0.1, 0.7),
				backgroundColor = ColorSequence.new(Color3.new(0.180392, 0.180392, 0.180392), Color3.new(0, 0, 0)),
				cornerRadius = UDim.new(0.1),
				padding = UDim.new(0.2),
				strokeWidth = 1.5,
				strokeColor = Color3.new(0, 0, 0),
			},
		},

		-- Background effects only work on runtime

		BackgroundBlur(),

		BackgroundColorCorrection {
			Brightness = -0.3,
			Saturation = -0.4,
		},
	}
end

return DeathScreen
