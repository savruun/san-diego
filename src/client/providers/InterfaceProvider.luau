--!strict

const Players = game:GetService('Players')

const vide = require('@pkg/vide')
const charm = require('@pkg/charm')
const icon = require('@pkg/topbarplus')

const atom = charm.atom

const paths = require('@shared/paths')
const iconIds = require('@shared/data/iconIds')
const safeChatOptions = require('@shared/data/safeChatOptions')

const App = require('@ui/components/App')
const net = require('../net')

const Player = Players.LocalPlayer
const playerGui = Player:WaitForChild('PlayerGui')

const InterfaceProvider = {
	__rootCleanup = function() end,
	page = atom<<string?>>(),
	mountedComponents = atom<<{ string }>>({}),

	icons = {
		ranks = icon.new(),
		safechat = icon.new(),
		settings = icon.new(),

		dropdowns = {
			safechat = {} :: { icon.Icon },
		},
	},
}

function InterfaceProvider.start(self: self): ()
	self.__rootCleanup = vide.mount(function() return App(self.page, self.mountedComponents) end, playerGui)

	self:__mountTopbar()
	self:__setDefaultValues()
end

--[[
	Mount a component by its name
]]
function InterfaceProvider.mountComponent(self: self, componentName: string): ()
	local componentExists = paths.interface.components:FindFirstChild(componentName) ~= nil
	if not componentExists then return warn('No component exists with name ', componentName) end

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
	if not pageExists then return warn('No page with name ', pageName) end

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

function InterfaceProvider.__mountTopbar(self: self)
	self.icons.ranks:setImage(iconIds.topbar.ranks):setLabel('Ranks')
	self.icons.settings:setImage(iconIds.topbar.setting):setLabel('Settings')

	for index, safeChatOption in safeChatOptions.armed do
		table.insert(
			self.icons.dropdowns.safechat,
			icon.new():setLabel(safeChatOption):oneClick(true):bindEvent('selected', function(...)
				self.icons.safechat:deselect()
				net.SaySafeChatOption.Fire(index)
			end)
		)
	end

	self.icons.safechat:setOrder(1):setImage(iconIds.topbar.chat):setDropdown(self.icons.dropdowns.safechat)
end

export type self = typeof(InterfaceProvider)
return InterfaceProvider
