const ServerScriptService = game:GetService('ServerScriptService')

const Component = require('@pkg/quill_rblx_components')
const Dependency = require('@pkg/quill_dependencies')
const Quill = require('@pkg/quill_core')
const Lifecycles = require('@pkg/quill_rblx_lifecycles')

const function getModules(): { ModuleScript }
	const descendants = ServerScriptService.server.providers:GetDescendants()
	local modules = {}

	for _, v in descendants do
		if not v:IsA('ModuleScript') then continue end
		table.insert(modules, v :: ModuleScript)
	end

	return modules
end

Quill.new():with_modules(getModules()):with_mod(Component.mod()):with_mod(Lifecycles.mod()):with_mod(Dependency.mod()):write()
