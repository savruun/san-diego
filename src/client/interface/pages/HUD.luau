local react = require('@packages/react')
local e = react.createElement

local function HUD()
	return e('Frame', {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
	}, {})
end

return HUD
