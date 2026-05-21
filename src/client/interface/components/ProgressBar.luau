const vide = require('@pkg/vide')
const create = vide.create
const indexes = vide.indexes
const derive = vide.derive

type Props = {
	name: string?,
	size: UDim2?,
	position: UDim2?,
	anchor: Vector2?,
	progress: vide.Source<{ current: number, max: number }>,
}

local PADDING = 4

local function ProgressBar(props: Props)
	local frames = derive(function()
		local progress = props.progress()
		local tab = {}

		for i = 1, progress.max do
			if i > progress.current then continue end
			tab[i] = true
		end

		return tab
	end)

	return create 'Frame' {
		Name = props.name,
		BackgroundColor3 = Color3.new(1, 0, 0),
		Size = props.size or UDim2.new(),
		Position = props.position or UDim2.new(),
		AnchorPoint = props.anchor or Vector2.zero,
		BackgroundTransparency = 1,

		create 'UIStroke' {
			Thickness = 1,
			Color = Color3.new(1, 1, 1),
		},

		create 'UIPadding' {
			PaddingBottom = UDim.new(0, 2),
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
			PaddingTop = UDim.new(0, 2),
		},

		create 'UIListLayout' {
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, PADDING),
		},

		indexes(frames, function(filled, index)
			print(index, filled)

			return create 'Frame' {
				LayoutOrder = index,
				Size = UDim2.fromScale(0.01, 0.9),
				Visible = filled,
				BackgroundColor3 = Color3.new(1, 1, 1),
			}
		end),
	}
end

return ProgressBar
