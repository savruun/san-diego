local function image(id) return `rbxassetid://{id}` end

const iconIds = {
	topbar = {
		ranks = image(123204329602159),
		setting = image(113397412612580),
	},

	hud = {
		shop = image(88312993212526),
		money = image(104344287837531),
		teams = image(135255732280184),
		hitmarker = image(125731639112354),
	},
}

return iconIds
