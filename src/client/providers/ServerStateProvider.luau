const net = require('@client/net')
const GunComponent = require('@client/components/Gun')

const playerTypes = require('@types/player')
const meta = require('@client/meta')

const ServerStateProvider = {}

function ServerStateProvider.start(self: self)
	self:connectListeners()

	-- Fetch the current player data
	const dataFuture = net.GetPersistentData:Invoke()
	const success, data = dataFuture:Await()

	-- If successful fetch, set player data
	if success then meta.playerData(data) end
end

function ServerStateProvider.connectListeners(self: self)
	-- When the server detects a gun state desync itll fire this to resync data
	net.SyncGunState.On(function(stateData)
		const gunInstance = GunComponent:get(stateData.instance)

		if gunInstance == nil then
			warn('Received gun state sync for an instance without a gun component')
			return
		end

		gunInstance.ammo(stateData.ammo)
		gunInstance.mode(stateData.mode)

		print('Successfully performed server requested resync for gun', gunInstance.instance.Name)
	end)

	-- Update player data when told by the server
	net.SyncPlayerData.On(function(data) meta.playerData(data) end)
end

export type self = typeof(ServerStateProvider)
return ServerStateProvider
