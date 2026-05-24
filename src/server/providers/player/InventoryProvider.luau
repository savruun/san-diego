const ServerStorage = game:GetService('ServerStorage')
const PlayerUtility = require('@shared/lib/playerUtility')
const Dependency = require('@pkg/quill_dependencies')

const net = require('@server/net')

const Tools = ServerStorage.assets.tools
const Guns = Tools.guns

type ToolType = 'Gun'

const InventoryProvider = {
	CombatProvider = Dependency.use(require('@ssingletons/combat/CombatProvider')),
}

function InventoryProvider.start(self: self)
	PlayerUtility:forEachPlayer(function(player)
		player.CharacterAdded:Connect(function(_character) self:givePlayerTool(player, 'Gun', 'Pistol') end)
	end)

	net.SyncInventoryState.On(
		function(player, inventory) print(`{player.Name} attempted to sync inventory state`, inventory) end
	)
end

function InventoryProvider.givePlayerTool(self: self, player: Player, toolType: ToolType, toolName: string)
	if toolType == 'Gun' then
		local gun: Tool? = Guns:FindFirstChild(toolName)
		if not gun then return end

		local newGun = gun:Clone()
		newGun.Parent = player.Backpack

		self.CombatProvider:registerPlayerGun(player, toolName, newGun)
	end
end

export type self = typeof(InventoryProvider)
return InventoryProvider
