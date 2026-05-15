--[[
  Takes a Color3 or ColorSequence and returns a darker version of it. The darkenAmount parameter is a number between 0 and 1 that determines how much darker the color should be. A value of 0 will return black, while a value of 1 will return the original color. The default value is 0.8, which will return a color that is 20% darker than the original.
]]
local function darken(color: Color3 | ColorSequence, darkenAmount: number): Color3
	if typeof(color) == 'Color3' then
		local h, s, v = color:ToHSV()
		return Color3.fromHSV(h, s, v * darkenAmount or 0.8)
	elseif typeof(color) == 'ColorSequence' then
		local newKeyPoints = {}

		for _, keyPoint in color.Keypoints do
			table.insert(newKeyPoints, ColorSequenceKeypoint.new(keyPoint.Time, darken(keyPoint.Value, darkenAmount or 0.8)))
		end
		return ColorSequence.new(newKeyPoints)
	end

	-- In theory this should never happen, but if it does, we return black so that it doesn't break the UI
	return Color3.new()
end

return darken
