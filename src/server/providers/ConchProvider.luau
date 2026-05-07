--!strict
const ServerScriptService = game:GetService('ServerScriptService')

const Conch = require('@pkg/conch')
const Logger = require('@pkg/quill_logger')

const playerUtility = require('@shared/lib/playerUtility')
const commandsFolder = ServerScriptService.server.commands

const ConchProvider = {
	__logger = Logger.new(script.Name, function(logged) end),
}

function ConchProvider.start(self: self)
	Conch.initiate_default_lifecycle()

	self:registerCommands()
	self:registerPermissions()

	self:bindEvents()
end

function ConchProvider.registerCommands(self: self)
	Conch.register_default_commands()

	for _, commandModule in commandsFolder:GetDescendants() do
		if not commandModule:IsA('ModuleScript') then continue end
		local _ = require(commandModule) :: any
	end
end

function ConchProvider.registerPermissions(self: self) Conch.set_role_permissions('admin', 'use_kick') end

function ConchProvider.bindEvents(self: self)
	playerUtility:forEachPlayer(function(player)
		local user = Conch.get_user(player)
		Conch.give_roles(user, 'super-user')
	end)
end

export type self = typeof(ConchProvider)
return ConchProvider
