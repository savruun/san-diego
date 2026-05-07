const RunService = game:GetService('RunService')

const vide = require('@pkg/vide')
const cleanup = vide.cleanup

local function useLerp(initial: number, goal: number, alpha: number)
  local src = vide.source(initial)

  local connection: RBXScriptConnection?
  connection = RunService.RenderStepped:Connect(function(delta: number)
    local current = src()

    local t = 1 - math.exp(-alpha * delta)
    local new = math.lerp(current, goal, t)

    if current >= goal and connection ~= nil then
      connection:Disconnect()
    end
    src(new)
  end)

  cleanup(function()
    if not connection then return end
    connection:Disconnect()
  end)

  return src
end

return useLerp
