--!strict
const ServerScriptService = game:GetService('ServerScriptService')

const conch = require('@pkg/conch')
const playerUtility = require('@shared/lib/playerUtility')
const logger = require('@pkg/quill-logger')

const commandsFolder = ServerScriptService.server.commands

const ConchProvider = {
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
		local _ = require(commandModule) :: any
	end
end

function ConchProvider.registerPermissions(self: self) conch.set_role_permissions('admin', 'use_kick') end

function ConchProvider.bindEvents(self: self)
	playerUtility:forEachPlayer(function(player)
		local user = conch.get_user(player)
		conch.give_roles(user, 'super-user')
	end)
end

export type self = typeof(ConchProvider)
return ConchProvider
