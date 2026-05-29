const vide = require('@pkg/vide')
const create = vide.create

type Props = {
	text: string?,
	size: UDim2?,
	position: UDim2?,
	anchor: Vector2?,
	corner: UDim?,
	color: ColorSequence?,
	textColor: Color3?,
	gradientRotation: number?,
	strokeColor: Color3?,
	padding: UDim?,
	font: Enum.Font?,
}

local function Button(props: Props)
	local hovering = vide.source(false)
	local size = vide.source(props.size or UDim2.fromScale(0.65, 0.13))
	local sizeSpring = vide.spring(size, 0.3)

	vide.effect(function()
		if hovering() then
			size(props.hoverSize or UDim2.fromScale(0.67, 0.15))
		else
			size(props.size or UDim2.fromScale(0.65, 0.13))
		end
	end)

	return create 'TextButton' {
		Position = props.position or UDim2.fromScale(0.5, 0.5),
		AnchorPoint = props.anchor or Vector2.new(0.5, 0.5),
		Size = sizeSpring,

		MouseEnter = function() hovering(true) end,

		MouseLeave = function() hovering(false) end,

		create 'UICorner' {
			CornerRadius = props.corner or UDim.new(0.2),
		},

		create 'UIStroke' {
			Thickness = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = props.strokeColor or Color3.new(0, 0, 0),
		},

		create 'UIGradient' {
			Rotation = 90,
			Color = props.color or ColorSequence.new(Color3.new(1, 1, 1), Color3.new(0, 0, 0)),
		},

		create 'TextLabel' {
			Text = props.text or 'Button',
			TextScaled = true,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			TextColor3 = props.textColor or Color3.new(1, 1, 1),
			Font = props.font or Enum.Font.Arimo,

			if props.padding
				then create 'UIPadding' {
					PaddingTop = props.padding,
					PaddingBottom = props.padding,
					PaddingLeft = props.padding,
					PaddingRight = props.padding,
				}
				else nil,
		},
	}
end

return Button
