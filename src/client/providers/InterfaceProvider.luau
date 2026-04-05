-- Services
const Players = game:GetService('Players')

-- Packages
const vide = require('@pkg/')

const App = require('@client/interface/components/App')
const paths = require('@shared/lib/paths')
const player = Players.LocalPlayer

-- Provider
const InterfaceProvider = {}

function InterfaceProvider.start(self: self): ()
end

export type self = typeof(InterfaceProvider)
return InterfaceProvider
