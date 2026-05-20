export type GunData = {
	damage: number,
	range: number,
	fireRate: number,
	ammoCapacity: number,
	reloadTime: number,
	bulletVelocity: number,
	defaultMode: GunFireMode,
	modes: {
		[GunFireMode]: GunFireModeData,
	},

	modifiers: GunModifier,
}

export type GunFireMode = 'auto' | 'semi' | 'burst'

export type GunFireModeData = {
	shots: number,
	interval: number?,
	spreadType: ('snapshot' | 'perShot')?,
	repeatWhileHeld: boolean,
}

export type GunModifier = {
	headshotMultiplier: number?,
	recoil: Vector2?,
	chargeTime: number?,
	useScope: boolean?,
}

const gunData = {
	Default = {
		damage = 10,
		range = 50,
		fireRate = 0.5,
		ammoCapacity = 12,
		reloadTime = 1.5,
		bulletVelocity = 400,

		defaultMode = 'semi',

		modes = {
			semi = {
				shots = 1,
			},

			auto = {
				shots = 1,
				repeatWhileHeld = true,
			},

			burst = {
				shots = 4,
				interval = 0.01,
			},
		},

		modifiers = {
			useScope = false,
			headshotMultiplier = 1,
			recoil = Vector2.zero,
			chargeTime = 0,
		},
	},

	Pistol = {
		damage = 10,
		range = 50,
		fireRate = 0.2,
		ammoCapacity = 12,
		reloadTime = 1.5,
		bulletVelocity = 400,

		defaultMode = 'semi',

		modes = {
			semi = {
				shots = 1,
			},

			burst = {
				shots = 4,
				interval = 0.03,
			},

			auto = {
				shots = 1,
				repeatWhileHeld = true,
			},
		},
	},
}

local function getDataFromName(gunType: keyof<typeof(gunData)> | string): GunData? return gunData[gunType] end

local function default(): GunData return gunData.Default end

local function normalizeMode(mode: GunFireModeData)
	return {
		shots = mode.shots or 1,
		interval = mode.interval or 0,
		repeatWhileHeld = mode.repeatWhileHeld or false,
		spreadType = mode.spreadType or 'perShot',
	}
end

local function normalizeGunData(data: GunData)
	const defaultData = default()

	local gunData = {
		damage = data.damage or defaultData.damage,
		range = data.range or defaultData.range,
		fireRate = data.fireRate or defaultData.fireRate,
		ammoCapacity = data.ammoCapacity or defaultData.ammoCapacity,
		reloadTime = data.reloadTime or defaultData.reloadTime,
		bulletVelocity = data.bulletVelocity or defaultData.bulletVelocity,
		defaultMode = data.defaultMode or defaultData.defaultMode,
		modes = data.modes or defaultData.modes,
		modifiers = data.modifiers or defaultData.modifiers,
	}

	-- Normalize all modes in the data
	for key, mode in gunData.modes do
		gunData.modes[key] = normalizeMode(mode)
	end

	return gunData
end

return {
	data = gunData,
	getDataFromName = getDataFromName,
	default = default,
	normalizeMode = normalizeMode,
	normalizeGunData = normalizeGunData,
}
