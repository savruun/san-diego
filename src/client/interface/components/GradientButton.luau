const vide = require('@pkg/vide')
const create = vide.create
const spring = vide.spring
const source = vide.source

const Children = require('@ui/components/Children')
const darken = require('@ui/util/darken')

type Props = {
	text: string?,
	font: Enum.Font?,
	textScaled: boolean?,
	backgroundColor: ColorSequence?,
	bgGradientRotation: number?,
	position: UDim2?,
	size: UDim2,
	padding: UDim?,
	maxSize: Vector2,
	minSize: Vector2,
	cornerRadius: UDim?,
	color: Color3?,
	strokeColor: Color3?,
	strokeTransparency: number?,
	strokeWidth: number?,
	aspectRatio: number?,
	onClick: (() -> ())?,

	[number]: GuiObject,
}

local function GradientButton(props: Props)
	local function useStroke()
		return props.strokeColor ~= nil or props.strokeTransparency ~= nil or props.strokeWidth ~= nil
	end

	local function useSizeConstraint() return props.maxSize ~= nil and props.minSize ~= nil end

	local size = source(props.size)
	local hovering = source(false)

	local sizeSpring = spring(size, 0.2)

	return create 'TextButton' {
		Position = props.position,
		Size = sizeSpring,
		Activated = props.onClick,

		MouseEnter = function()
			hovering(true)
			size(props.size + UDim2.fromOffset(4, 4))
		end,

		MouseLeave = function()
			hovering(false)
			size(props.size)
		end,

		create 'UIAspectRatioConstraint' {
			AspectRatio = props.aspectRatio or 1,
		},

		create 'UIGradient' {
			Color = function()
				if hovering() then
					return darken(
						props.backgroundColor or ColorSequence.new(Color3.new(1, 1, 1), Color3.new(0.792157, 0.792157, 0.792157))
					)
				else
					return props.backgroundColor
						or ColorSequence.new(Color3.new(1, 1, 1), Color3.new(0.792157, 0.792157, 0.792157))
				end
			end,
			Rotation = props.bgGradientRotation or 90,
		},

		create 'TextLabel' {
			Text = props.text or 'Gradient Button',
			Font = props.font or Enum.Font.Arial,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			TextScaled = props.textScaled or false,
			TextColor3 = props.color or Color3.new(),
		},

		if props.padding ~= nil
			then create 'UIPadding' {
				PaddingTop = props.padding,
				PaddingBottom = props.padding,
				PaddingLeft = props.padding,
				PaddingRight = props.padding,
			}
			else nil,

		if props.cornerRadius ~= nil
			then create 'UICorner' {
				CornerRadius = props.cornerRadius,
			}
			else nil,

		if useStroke()
			then create 'UIStroke' {
				Color = props.strokeColor or Color3.new(0, 0, 0),
				Transparency = props.strokeTransparency or 0,
				Thickness = props.strokeWidth or 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			}
			else nil,

		if useSizeConstraint()
			then create 'UISizeConstraint' {
				MaxSize = props.maxSize,
				MinSize = props.minSize,
			}
			else nil,

		Children(props),
	}
end

return GradientButton
