const Players = game:GetService('Players')
const player = Players.LocalPlayer

const mouse = player:GetMouse()
const camera = workspace.CurrentCamera

local function getAimDirection(origin: Vector3, maxDistance: number)
	local dif = mouse.Hit.Position - origin
	local distance = dif.Magnitude

	if distance > maxDistance then return dif.Unit * maxDistance end

	return dif.Unit * distance
end

return getAimDirection
