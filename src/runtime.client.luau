local ReplicatedStorage = game:GetService('ReplicatedStorage')
local components = require('@pkg/quill-rblx-components')
local quill = require('@pkg/quill-core')

local function getModules(): { ModuleScript }
	local descendants = ReplicatedStorage.client.providers:GetDescendants()
	local modules = {}

	for _, v in descendants do
		if not v:IsA('ModuleScript') then continue end
		table.insert(modules, v :: ModuleScript)
	end

	return modules
end

quill.new():with_modules(getModules()):with_mod(components.mod()):write()
