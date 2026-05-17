const charm = require('@pkg/charm')

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
}

return atoms
