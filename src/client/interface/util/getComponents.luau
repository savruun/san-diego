const paths = require('@shared/paths')

local components = {}
for _, mod in paths.interface.components:GetDescendants() do
  if not mod:IsA('ModuleScript') or mod.Name == 'App' then continue end
  components[mod.Name] = require(mod) :: () -> Instance
end

local function getComponents()
  return components
end


return getComponents
