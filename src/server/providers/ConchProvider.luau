--!strict
local ServerScriptService = game:GetService('ServerScriptService')

local conch = require('@pkg/conch')
local forEachPlayer = require('@shared/lib/forEachPlayer')
local logger = require('@pkg/quill-logger')

local commandsFolder = ServerScriptService.server.commands

local ConchProvider = {
	__logger = logger.new(script.Name, function(logged) end),
}

function ConchProvider.start(self: self)
	conch.initiate_default_lifecycle()

	self:registerCommands()
	self:registerPermissions()

	self:bindEvents()
end

function ConchProvider.registerCommands(self: self)
	conch.register_default_commands()

	for _, commandModule in commandsFolder:GetDescendants() do
		if not commandModule:IsA('ModuleScript') then continue end
		xpcall(function() end, warn)
	end
end

function ConchProvider.registerPermissions(self: self) conch.set_role_permissions('admin', 'use_kick') end

function ConchProvider.bindEvents(self: self)
	forEachPlayer(function(player)
		local user = conch.get_user(player)
		conch.give_roles(user, 'super-user')
	end)
end

export type self = typeof(ConchProvider)
return ConchProvider
