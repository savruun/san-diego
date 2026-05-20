local function image(id) return `rbxassetid://{id}` end

const iconIds = {
	topbar = {
		ranks = image(90479647221131),
		setting = image(134899927732100),
		chat = image(121373820642208),
	},

	hud = {
		shop = image(88312993212526),
		money = image(104344287837531),
		teams = image(135255732280184),
		hitmarker = image(125731639112354),
	},
}

return iconIds
