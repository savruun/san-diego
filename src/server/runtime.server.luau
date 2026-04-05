const ServerScriptService = game:GetService('ServerScriptService')
const quill = require('@pkg/quill-core')
const component = require('@pkg/quill-rblx-components')

const function getModules(): {ModuleScript}
	local descendants = ServerScriptService.server.providers:GetDescendants()
	local modules = {}

	for _, v in descendants do
		if not v:IsA('ModuleScript') then continue end
		table.insert(modules, v :: ModuleScript)
	end

	return modules
end

quill.new():with_modules(getModules()):with_mod(component.mod()):write()
