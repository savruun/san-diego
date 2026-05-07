const Players = game:GetService('Players')
const player = Players.LocalPlayer

const mouse = player:GetMouse()
const camera = workspace.CurrentCamera

local function getAimDirection()
  local ray = camera:ScreenPointToRay(mouse.X, mouse.Y)
  return ray.Direction.Unit
end


return getAimDirection
