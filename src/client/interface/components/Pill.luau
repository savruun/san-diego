const vide = require('@pkg/vide')
const create = vide.create

const Children = require('@ui/components/Children')

type Props = {
	size: UDim2?,
	strokeColor: Color3?,
	strokeWidth: number?,
	color: Color3?,

	[number]: GuiObject,
}

local function Pill(props: Props)
	return create 'Frame' {
		Size = UDim2.fromScale(0.4, 0.08),
		AnchorPoint = Vector2.new(0.5),
		Position = UDim2.fromScale(0.5, 0.17),
		BackgroundColor3 = props.color or Color3.new(0.133333, 0.133333, 0.133333),

		create 'UICorner' {
			CornerRadius = UDim.new(1),
		},

		create 'UIStroke' {
			Color = props.strokeColor or Color3.new(0.423529, 0.423529, 0.423529),
			Thickness = props.strokeWidth,
		},

		Children(props),
	}
end

return Pill
