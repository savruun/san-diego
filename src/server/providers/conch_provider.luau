local conch = require('@packages/conch')
local for_each_player = require('@shared/lib/for_each_player')
local logger = require('@packages/quill-logger')

local commands_folder = script.Parent.Parent.commands

local conch_provider = {
	__logger = logger.new(script.Name, function(logged) end),
}

function conch_provider.start(self: self)
	conch.initiate_default_lifecycle()

	self:register_commands()
	self:register_permissions()
	self:bind_events()
end

function conch_provider.register_commands(self: self)
	conch.register_default_commands()

	for _, command_module in commands_folder:GetDescendants() do
		if not command_module:IsA('ModuleScript') then continue end
		xpcall(function() require(command_module) end, warn)
	end
end

function conch_provider.register_permissions(self: self) conch.set_role_permissions('admin', { 'use_kick' }) end

function conch_provider.bind_events(self: self)
	for_each_player(function(player)
		local user = conch.get_user(player)
		conch.give_roles(user, 'super-user')
	end)
end

export type self = typeof(conch_provider)
return conch_provider
