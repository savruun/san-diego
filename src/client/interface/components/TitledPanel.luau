const vide = require('@pkg/vide')
const create = vide.create

const Children = require('@ui/components/Children')
const Card = require('@ui/components/Card')
const Label = require('@ui/components/Label')

type Props = {
	text: string,
	icon: string,

	[number]: GuiObject,
}

local function TitledPanel(props: Props)
	return Card {
		position = UDim2.fromScale(0.5, 0.5),
		anchorPoint = Vector2.new(0.5, 0.5),
		size = UDim2.fromScale(0.8, 0.8),
		aspectRatio = 1.2,
		transparency = 0.2,
		corner = UDim.new(0.01),

		create 'UISizeConstraint' {
			MaxSize = Vector2.new(800, 800),
		},

		create 'UIListLayout' {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
		},

		create 'Frame' {
			Size = UDim2.fromScale(0.92, 0.09),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0),

			create 'UIListLayout' {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0.03),
			},

			create 'UIPadding' {
				PaddingTop = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 5),
			},

			create 'ImageLabel' {
				Image = props.icon,
				Size = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,

				create 'UIAspectRatioConstraint' {
					AspectRatio = 1,
				},
			},

			Label {
				text = props.text,
				font = Enum.Font.ArimoBold,
				scaled = true,
				size = UDim2.fromScale(0.4, 0.4),
				position = UDim2.fromScale(0.025, 0),
				xAlignment = Enum.TextXAlignment.Left,
				color = Color3.new(1, 1, 1),
			},
		},

		Children(props),
	}
end

return TitledPanel
