--!strict

local conch = require('@pkg/conch')
local conchUi = require('@pkg/conch-ui')

local ConchProvider = {}

function ConchProvider.start(self: self) self:startConch() end

function ConchProvider.startConch(self: self)
	conch.initiate_default_lifecycle()
	conchUi.bind_to(Enum.KeyCode.F2)
end

export type self = typeof(ConchProvider)
return ConchProvider
