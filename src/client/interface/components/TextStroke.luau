const vide = require('@pkg/vide')
const create = vide.create

const Children = require('@ui/components/Children')

type Props = {
	color: Color3?,
	thickness: number?,
	[number]: GuiObject,
}

local function TextStroke(props: Props?)
	props = props or {}

	return create 'UIStroke' {
		Color = props.color or Color3.new(0, 0, 0),
		Thickness = props.thickness or 2,

		Children(props),
	}
end

return TextStroke
