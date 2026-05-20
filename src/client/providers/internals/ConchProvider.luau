const Conch = require('@pkg/conch')
const ConchUi = require('@pkg/conch-ui')

const ConchProvider = {}

function ConchProvider.start(self: self) self:__startConch() end

function ConchProvider.__startConch(self: self)
	Conch.initiate_default_lifecycle()
	ConchUi.bind_to(Enum.KeyCode.F2)
end

export type self = typeof(ConchProvider)
return ConchProvider
