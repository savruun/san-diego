const ReplicatedStorage = game:GetService('ReplicatedStorage')
const components = require('@pkg/quill_rblx_components')
const quill = require('@pkg/quill_core')

const function getModules(): { ModuleScript }
	const descendants = ReplicatedStorage.client.providers:GetDescendants()
	local modules = {}

	for _, v in descendants do
		if not v:IsA('ModuleScript') then continue end
		table.insert(modules, v :: ModuleScript)
	end

	return modules
end

quill.new():with_modules(getModules()):with_mod(components.mod()):write()
