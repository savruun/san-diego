-- Services
local Players = game:GetService('Players')
local StarterGui = game:GetService('StarterGui')

-- Packages
local vide = require('@pkg/vide')
local root = vide.root

local App = require('@client/interface/components/App')
local paths = require('@shared/paths')
local player = Players.LocalPlayer

local InterfaceProvider = {
	__rootCleanup = nil :: () -> (),
}

function InterfaceProvider.start(self: self): () self.__rootCleanup = vide.mount(App, StarterGui) end

function InterfaceProvider.cleanup(self: self) self.__rootCleanup() end

export type self = typeof(InterfaceProvider)
return InterfaceProvider
