--!strict

-- Services
const Players = game:GetService('Players')

const App = require('@ui/components/App')
const vide = require('@pkg/vide')
local paths = require('@shared/paths')
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

	self:__setDefaultValues()
end

--[[
	Mount a component by its name
]]
function InterfaceProvider.mountComponent(self: self, componentName: string): ()
	local componentExists = paths.interface.components:FindFirstChild(componentName) ~= nil
	if not componentExists then
		return warn('No component exists with name ', componentName)
	end
	
	local currentValue = self.mountedComponents()
	table.insert(currentValue, componentName)

	self.mountedComponents(currentValue)
end

--[[
	Unmount a component by its name
]]
function InterfaceProvider.unmountComponent(self: self, componentName: string): ()
	local currentValue = self.mountedComponents()

	local index = table.find(currentValue, componentName)
	if not index then return end
	
	table.remove(currentValue, index)
	self.mountedComponents(currentValue)
end

--[[
	Sets the current page rendered
]]
function InterfaceProvider.setPage(self: self, pageName: string): ()
	local pageExists = paths.interface.pages:FindFirstChild(pageName) ~= nil
	if not pageExists then
		return warn('No page with name ', pageName)
	end

	self.page(pageName)
end

function InterfaceProvider.cleanup(self: self) self.__rootCleanup() end

--[[
	Sets the InterfaceProvider properties to their default values
]]
function InterfaceProvider.__setDefaultValues(self: self)
	self.page('HUD')
	self.mountedComponents({ 'CharacterSidebarContainer' })
end

export type self = typeof(InterfaceProvider)
return InterfaceProvider
