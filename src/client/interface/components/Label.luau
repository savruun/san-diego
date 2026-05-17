const vide = require('@pkg/vide')
const create = vide.create

const Children = require('@ui/components/Children')

type Props = {
	text: string,
	order: number?,
	color: Color3?,
	position: UDim2?,
	size: UDim2?,
	font: Enum.Font?,
	scaled: boolean?,

	button: boolean?,
	onClick: () -> ()?,

	[number]: GuiObject,
}

local function Label(props: Props): TextButton | TextLabel
	local elementName = props.button and 'TextButton' or 'TextLabel'

	return create(elementName) {
		TextColor3 = props.color,
		LayoutOrder = props.order,
		BackgroundTransparency = 1,
		Size = props.size,
		Position = props.position,
		Font = props.font or Enum.Font.Arimo,
		Text = props.text,
		TextScaled = props.scaled,

		Children(props),
	}
end

return Label
