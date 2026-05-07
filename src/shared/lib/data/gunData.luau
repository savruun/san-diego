export type GunData = {
	damage: number,
	range: number,
	fireRate: number,
	ammoCapacity: number,
	reloadTime: number,
	bulletVelocity: number,
	mode: 'auto' | 'semi' | 'sniper' | 'burst' | 'shotgun',
}

const gunData = {
	Pistol = {
		damage = 10,
		range = 100,
		fireRate = 0.5,
		ammoCapacity = 12,
		reloadTime = 1.5,
		bulletVelocity = 400,
		mode = 'auto',
	},
}

local function getDataFromName(gunType: keyof<typeof(gunData)> | string): GunData?
  return gunData[gunType]
end

local function default(): GunData
	return gunData.Pistol
end

return {
  data = gunData,
  getDataFromName = getDataFromName,
	default = default
}
