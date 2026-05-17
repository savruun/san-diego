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

return {
	data = gunData,
	getDataFromName = getDataFromName,
	default = default,
	normalizeMode = normalizeMode,
}
