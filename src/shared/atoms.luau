const charm = require('@pkg/charm')
const playerTypes = require('@types/player')

type AmmoData = {
	current: number,
	max: number,
}

const atoms = {
	gun = {
		ammo = charm.atom<<AmmoData>>({ current = 0, max = 0 }),
		mode = charm.atom<<string>>(''),
		name = charm.atom<<string>>(''),
	},

	playerData = charm.atom<<playerTypes.SafePlayerData>>(),
}

return atoms
