const vide = require('@pkg/vide')
const create = vide.create

const Children = require('@ui/components/Children')

type Props = {
	size: UDim2,
	position: UDim2,
	color: ColorSequence,
	transparency: NumberSequence?,
	strokecolor: ColorSequence?,
	stroketransparency: NumberSequence?,
	strokewidth: number,
	anchor: Vector2?,
	name: string?,

	[number]: GuiObject,
}

local function GradientBanner(props: Props)
	return create 'Frame' {
		Name = props.name or 'GradientBar',
		Size = props.size,
		Position = props.position,
		AnchorPoint = props.anchor or Vector2.new(0.5),

		create 'UIGradient' {
			Color = props.color,
			Transparency = props.transparency,
		},

		if props.strokecolor ~= nil
			then create 'UIStroke' {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.new(1, 1, 1), -- White so gradient applys
				Thickness = props.strokewidth,

				create 'UIGradient' {
					Color = props.strokecolor,
					Transparency = props.stroketransparency,
				},
			}
			else nil,

		Children(props),
	}
end

return GradientBanner
