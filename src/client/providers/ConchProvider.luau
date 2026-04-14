--!strict

const conch = require('@pkg/conch')
const conchUi = require('@pkg/conch-ui')

const ConchProvider = {}

function ConchProvider.start(self: self) self:startConch() end

function ConchProvider.startConch(self: self)
	conch.initiate_default_lifecycle()
	conchUi.bind_to(Enum.KeyCode.F2)
end

export type self = typeof(ConchProvider)
return ConchProvider
