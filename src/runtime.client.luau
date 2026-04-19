const ReplicatedStorage = game:GetService('ReplicatedStorage')
const components = require('@pkg/quill_rblx_components')
const dependency = require('@pkg/quill_dependencies')
const quill = require('@pkg/quill_core')
const lifecycles = require('@pkg/quill_rblx_lifecycles')

const function getModules(): { ModuleScript }
	const descendants = ReplicatedStorage.client.providers:GetDescendants()
	local modules = {}

	for _, v in descendants do
		if not v:IsA('ModuleScript') then continue end
		table.insert(modules, v :: ModuleScript)
	end

	return modules
end

quill.new():with_modules(getModules()):with_mod(components.mod()):with_mod(lifecycles.mod()):with_mod(dependency.mod()):write()
