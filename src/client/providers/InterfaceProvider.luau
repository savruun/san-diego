--!strict

-- Services
const Players = game:GetService('Players')

const App = require('@ui/components/App')
const vide = require('@pkg/vide')
const charm = require('@pkg/charm')

const atom = charm.atom
const player = Players.LocalPlayer

const InterfaceProvider = {
	__rootCleanup = function() end,
	page = atom<<string?>>(),
	mountedComponents = atom<<{ string }>>({})
}

function InterfaceProvider.start(self: self): ()
	const playerGui = player:WaitForChild('PlayerGui')

	self.__rootCleanup = vide.mount(function()
		return App(self.page, self.mountedComponents)
	end, playerGui)

	self:setDefaultValues()
end
 
function InterfaceProvider.setDefaultValues(self: self)
	self.page('HUD')
	self.mountedComponents({ 'CharacterSidebarContainer' })
end

function InterfaceProvider.cleanup(self: self) self.__rootCleanup() end

export type self = typeof(InterfaceProvider)
return InterfaceProvider
