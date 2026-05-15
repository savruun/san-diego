const components = require('@pkg/quill_rblx_components')
const dependency = require('@pkg/quill_dependencies')
const quill = require('@pkg/quill_core')
const lifecycles = require('@pkg/quill_rblx_lifecycles')
const paths = require('@shared/paths')

local function getModules(): { ModuleScript }
	local providerInstances = paths.client.providers:GetDescendants()
	local componentInstances = paths.client.components:GetChildren()

	local modules = {}

	for _, v in providerInstances do
		if v:IsA('ModuleScript') then
			table.insert(modules, v)
		end
	end

	for _, v in componentInstances do
		if v:IsA('ModuleScript') then
			table.insert(modules, v)
		end
	end

	return modules
end

quill.new():with_modules(getModules()):with_mod(components.mod()):with_mod(lifecycles.mod()):with_mod(dependency.mod()):write()
