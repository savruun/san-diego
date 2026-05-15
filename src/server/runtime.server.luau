const Component = require('@pkg/quill_rblx_components')
const Dependency = require('@pkg/quill_dependencies')
const Quill = require('@pkg/quill_core')
const Lifecycles = require('@pkg/quill_rblx_lifecycles')
local paths = require("@shared/paths")

local function getModules(): { ModuleScript }
  -- This will always exist, this is just here for intellisense
  if not paths.server then return end

  const componentsFolder = paths.server:FindFirstChild('components')
  const providersFolder = paths.server:FindFirstChild('providers')

	const providerInstances = providersFolder and providersFolder:GetDescendants()
  const componentInstances = componentsFolder and componentsFolder:GetDescendants()

  
	local modules = {}
  
	for _, v in providerInstances or {} do
		if v:IsA('ModuleScript') then
			table.insert(modules, v)
		end
	end

	for _, v in componentInstances or {} do
		if v:IsA('ModuleScript') then
			table.insert(modules, v)
		end
	end

	return modules
end

Quill.new():with_modules(getModules()):with_mod(Component.mod()):with_mod(Lifecycles.mod()):with_mod(Dependency.mod()):write()
