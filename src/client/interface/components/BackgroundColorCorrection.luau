const vide = require('@pkg/vide')
const create = vide.create
const cleanup = vide.cleanup
const source = vide.source
const spring = vide.spring

const camera = workspace.CurrentCamera

type Props = {
	saturation: number?,
	brightness: number?,
	contrast: number?,
}

local function BackgroundColorCorrection(props: Props?)
	props = props or {}

	local saturation = source(0)
	local brightness = source(0)
	local contrast = source(0)

	local saturationSpring = spring(saturation)
	local brightnessSpring = spring(brightness)
	local contrastSpring = spring(contrast)

	task.delay(0.5, function()
		saturation(props.saturation or 0)
		brightness(props.brightness or 0)
		contrast(props.contrast or 0)
	end)

	return create 'ColorCorrectionEffect' {
		Parent = camera,
		Saturation = saturationSpring,
		Brightness = brightnessSpring,
		Contrast = contrastSpring,
	}
end

return BackgroundColorCorrection
