const vide = require('@pkg/vide')
const create = vide.create

const function HUD()
	return create 'Frame' {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1
	}
end

return HUD
