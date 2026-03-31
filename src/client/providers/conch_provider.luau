local conch = require('@packages/conch')
local conch_ui = require('@packages/conch_ui')

local conch_provider = {}

function conch_provider.start(self: self) self:start_conch() end

function conch_provider.start_conch(self: self)
	conch.initiate_default_lifecycle()
	conch_ui.bind_to(Enum.KeyCode.F2)
end

export type self = typeof(conch_provider)
return conch_provider
