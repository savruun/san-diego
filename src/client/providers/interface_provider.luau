-- Services
local Players = game:GetService('Players')

-- Packages
local react = require('@packages/react')
local react_roblox = require('@packages/react-roblox')

local App = require('@client/interface/components/App')
local paths = require('@shared/lib/paths')
local player = Players.LocalPlayer

-- React localizations
local e = react.createElement

-- Provider
local interface_provider = {
	__root = react_roblox.createRoot(Instance.new('Folder')),
}

function interface_provider.start(self: self): ()
	self.__root:render(react_roblox.createPortal(e(App), player:WaitForChild('PlayerGui')))
end

export type self = typeof(interface_provider)
return interface_provider
