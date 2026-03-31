local ServerScriptService = game:GetService('ServerScriptService')
local quill = require('@packages/quill-core')
local quill_component = require('@packages/quill-rblx-components')

local function get_modules()
	local descendants = ServerScriptService.server.providers:GetDescendants()
	local modules = {}

	for _, v in descendants do
		if not v:IsA('ModuleScript') then continue end
		table.insert(modules, v :: ModuleScript)
	end

	return modules
end

quill.new():with_modules(get_modules()):with_mod(quill_component.mod()):write()
