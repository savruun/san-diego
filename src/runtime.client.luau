local ReplicatedStorage = game:GetService('ReplicatedStorage')
local quill = require('@packages/quill-core')
local quill_components = require('@packages/quill-rblx-components')

local function get_modules()
	local descendants = ReplicatedStorage.client.providers:GetDescendants()
	local modules = {}

	for _, v in descendants do
		if not v:IsA('ModuleScript') then continue end
		table.insert(modules, v :: ModuleScript)
	end

	return modules
end

quill.new():with_modules(get_modules()):with_mod(quill_components.mod()):write()
