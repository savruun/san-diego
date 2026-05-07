const components = require('@pkg/quill_rblx_components')
const dependency = require('@pkg/quill_dependencies')
const quill = require('@pkg/quill_core')
const lifecycles = require('@pkg/quill_rblx_lifecycles')
local paths = require('@shared/paths')

const function getModules(): { ModuleScript }
	const providerInstances = paths.client.providers:GetDescendants()
	const componentInstances = { table.unpack(paths.client.components:GetChildren()) }

	local modules = {}

	-- Iterate thru all providers and components to load
	for _, v in { table.unpack(providerInstances), table.unpack(componentInstances) } do
		if not v:IsA('ModuleScript') then continue end
		table.insert(modules, v :: ModuleScript)
	end

	return modules
end


quill.new():with_modules(getModules()):with_mod(components.mod()):with_mod(lifecycles.mod()):with_mod(dependency.mod()):write()
