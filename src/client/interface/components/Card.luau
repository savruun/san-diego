const vide = require('@pkg/vide')
const create = vide.create

const Children = require('@ui/components/Children')
const theme = require('@ui/theme')

type Props = {
	color: Color3?,
	transparency: number?,
	strokeTransparency: number?,
	strokeColor: Color3?,
	strokeWidth: number?,
	size: UDim2,
	position: UDim2,
	anchorPoint: Vector2,
	name: string?,
	aspectRatio: number?,
	corner: UDim?,
	order: number?,
	texture: string?,
	textureScaleType: Enum.ScaleType?,
	textureSliceScale: number?,

	[number]: GuiObject,
}

local function Card(props: Props)
	return create 'Frame' {
		Name = props.name,
		BackgroundColor3 = props.color or Color3.new(),
		BackgroundTransparency = props.transparency or 0.5,
		Size = props.size,
		Position = props.position,
		AnchorPoint = props.anchorPoint,
		LayoutOrder = props.order,

		create 'UIStroke' {
			Color = props.strokeColor or theme.ashBorder,
			Thickness = props.strokeWidth or 2,
			Transparency = props.strokeTransparency or 0.35,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		},

		if props.texture
			then create 'ImageLabel' {
				Size = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = props.texture,
				BackgroundTransparency = 1,
				ZIndex = -1,
				ScaleType = props.textureScaleType,
				SliceScale = props.textureSliceScale,

				create 'UICorner' {
					CornerRadius = props.corner or 0.05,
				},
			}
			else nil,

		if props.aspectRatio
			then create 'UIAspectRatioConstraint' {
				AspectRatio = props.aspectRatio,
			}
			else nil,

		create 'UICorner' {
			CornerRadius = props.corner or 0.05,
		},

		Children(props),
	}
end

return Card
