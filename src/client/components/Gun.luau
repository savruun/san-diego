--!strict
const RunService = game:GetService('RunService')
const Players = game:GetService('Players')

const components = require('@pkg/quill_rblx_components')
const charm = require('@pkg/charm')
const ezinput = require('@pkg/ezinput')
const trove = require('@pkg/trove')

const CombatProvider = require('@csingletons/combat/CombatProvider')

const gunData = require('@shared/data/gunData')
const cursorIds = require('@shared/data/cursorIds')
const atoms = require('@shared/atoms')

const getAimDirection = require('@shared/lib/getAimDirection')

const net = require('@client/net')

const Player = Players.LocalPlayer
const mouse = Player:GetMouse()

-- Enums reflecting gun state
const GunStateEnum = table.freeze {
	Firing = 'FIRING',
	Patrolling = 'PATROLLING',
	Idle = 'IDLE',
	Unequipped = 'UNEQUIPPED',
	Reloading = 'RELOADING',
}

type GunData = gunData.GunData

local componentRegistry = {} :: { [Instance]: self }

const Gun = {}
Gun.__index = Gun

type GunProperties = {
	instance: Tool,
	handle: BasePart,
	tip: Attachment,

	data: GunData,
	state: string,

	trove: trove.Trove,
	equippedTrove: trove.Trove?,
	firingTrove: trove.Trove?,
	input: ezinput.ContextBuilder?,

	ammo: charm.Atom<number>,
	mode: charm.Atom<gunData.GunFireMode>,
	lastFiredAt: number,
	modeOrder: { string },
}

export type self = setmetatable<GunProperties, typeof(Gun)>

--[[
  Initializes the gun.
]]
function Gun.init(self: self): ()
	self.trove:AttachToInstance(self.instance)

	self.trove:Add(self.instance.Equipped:Connect(function() self:__onEquipped() end))
	self.trove:Add(self.instance.Unequipped:Connect(function() self:__onUnequipped() end))

	-- Cache modes in order

	self.modeOrder = {}

	for mode, _ in self.data.modes do
		table.insert(self.modeOrder, mode)
	end
end

function Gun.destroy(self: self): ()
	-- Unregisters the gun
	componentRegistry[self.instance] = nil

	self.trove:Clean()
end

--[[
  Simulates a trigger pull.
]]
function Gun.pullTrigger(self: self): ()
	if self.ammo() <= 0 then
		warn('client out of ammo')
		return
	end

	local mode = gunData.normalizeMode(self.data.modes[self.mode()])
	if not mode then return end

	local shots = math.min(mode.shots, self.ammo())
	local nextAmmo = self.ammo() - shots

	-- Predict ammo locally
	self.ammo(nextAmmo)

	-- Update ui for ammo purposes
	self:__updateUiAtoms()

	local origin = self.tip.WorldPosition
	local directions = table.create<<Vector3>>(shots) -- Create a table with the length of the number of shots to take

	for i = 1, shots do
		local direction = getAimDirection(origin, self.data.range)
		directions[i] = direction

		-- Immediately render bullet for client responsiveness
		CombatProvider:renderBullet({
			position = origin,
			origin = self.tip,
			direction = direction,
			range = self.data.range,
			velocity = self.data.bulletVelocity,
		})

		-- Don't wait after final bullet
		if i < shots then task.wait(mode.interval) end
	end

	-- Tell the server to process the gun fire
	net.FireGun.Fire({
		origin = origin,
		directions = directions,
		ammo = nextAmmo,
		gunType = self.instance.Name,
		timestamp = os.clock(),
	})

	self.lastFiredAt = os.clock()
end

--[[
  Starts firing the gun in a behavior based on its current mode.
]]
function Gun.startFiring(self: self)
	if self.equippedTrove == nil then return end

	self.state = GunStateEnum.Firing
	self.firingTrove = self.equippedTrove:Extend()

	local mode = gunData.normalizeMode(self.data.modes[self.mode()])
	if not mode then return end

	if mode.repeatWhileHeld then
		self.firingTrove:Add(RunService.Heartbeat:Connect(function()
			if not self:canFire() then return end

			self:pullTrigger()
		end))
	else
		if not self:canFire() then return end

		self:pullTrigger()
	end
end

--[[
  Halts automatic firing loops by cleaning the firing trove.
]]
function Gun.stopFiring(self: self)
	if not self.firingTrove then return end

	self.firingTrove:Clean()
	self.state = GunStateEnum.Idle
end

--[[
  Returns whether the difference in the current time from the last fire time is greater than the fire rate.
]]
function Gun.canFire(self: self) return os.clock() - self.lastFiredAt > self.data.fireRate end

function Gun.reload(self: self): ()
	local ammo = self.ammo()

	if ammo >= self.data.ammoCapacity then return end

	self.ammo(self.data.ammoCapacity)

	-- Communicate to the server that we have reloaded and what ammo was at the time of reload incase of desync
	net.ReloadGun.Fire({
		ammo = ammo,
		mode = self.mode(),
		instance = self.instance,
	})

	self:__updateUiAtoms()
end

--[[
  Puts the gun on safety, aiming it down at the ground.
]]
function Gun.patrol(self: self): ()
	if self.state ~= GunStateEnum.Idle then return end

	print('patrol arms')
end

function Gun.switchMode(self: self)
	if self.state ~= GunStateEnum.Idle then return end

	local currentMode = self.mode()

	local currentIndex = table.find(self.modeOrder, currentMode)
	if not currentIndex then return end

	local nextMode = self.modeOrder[currentIndex + 1] or self.modeOrder[1]
	self.mode(nextMode)

	self:__updateUiAtoms()

	net.SwitchGunMode.Fire({
		gunType = self.instance.Name,
		mode = nextMode,
	})
end

function Gun.__updateUiAtoms(self: self)
	atoms.gun.ammo({ current = self.ammo(), max = self.data.ammoCapacity })
	atoms.gun.mode(self.mode())
	atoms.gun.name(self.instance.Name)
end
--[[
  Runs on equipped.
]]
function Gun.__onEquipped(self: self): ()
	self.equippedTrove = self.trove:Extend()
	self.input = ezinput.context('gun')
	self.state = GunStateEnum.Idle

	mouse.Icon = cursorIds.Default

	self:__attachInput()
	self:__updateUiAtoms()
end

--[[
  Runs on unequipped.
]]
function Gun.__onUnequipped(self: self): ()
	if self.equippedTrove then
		self.equippedTrove:Clean()
		self.equippedTrove = nil
	end

	-- If the gun is firing, stop firing
	if self.state == GunStateEnum.Firing then self:stopFiring() end

	self.state = GunStateEnum.Unequipped
	mouse.Icon = ''
end

--[[
  Attaches all inputs to their corresponding methods.
]]
function Gun.__attachInput(self: self): ()
	local input = self.input
	local equippedTrove = self.equippedTrove

	if not input or not equippedTrove then return end

	input
		:action('fire')
		:bind(Enum.KeyCode.MouseLeftButton)
		:action()
		:onPressed(function() self:startFiring() end)
		:onReleased(function() self:stopFiring() end)

	input:action('reload'):bind(Enum.KeyCode.R):action():onPressed(function() self:reload() end)

	input:action('patrol'):bind(Enum.KeyCode.F):action():onPressed(function() self:patrol() end)

	input:action('mode'):bind(Enum.KeyCode.Y):action():onPressed(function() self:switchMode() end)

	equippedTrove:Add(function() input:destroy() end)
end

const GunComponent = {}

GunComponent.info = components.info({
	is = components.singleton('Tool'),
	tag = components.singleton('Gun'),

	children = {
		Handle = components.child('BasePart'),
		Tip = components.child('Attachment'),
	},
})

function GunComponent:new(data: components.CreationData<typeof(GunComponent.info)>): self
	local gun = setmetatable({}, Gun) :: self

	local instance = data.instance :: Tool
	local gunInfo = gunData.getDataFromName(instance.Name) or gunData.default()

	gun.instance = instance
	gun.handle = data.children.Handle
	gun.tip = data.children.Tip

	gun.data = gunInfo

	gun.trove = trove.new()

	gun.ammo = charm.atom(gunInfo.ammoCapacity)
	gun.mode = charm.atom(gunInfo.defaultMode)
	gun.state = GunStateEnum.Unequipped

	gun.lastFiredAt = 0

	componentRegistry[instance] = gun

	return gun
end

--[[
  Get the Component instance which was instantiated for the given Instance.
]]
function GunComponent:get(instance: Instance): self? return componentRegistry[instance] end

return GunComponent
