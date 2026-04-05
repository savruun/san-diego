-- Packages
local usePage = require("@client/interface/hooks/usePage")
const vide = require('@pkg/vide')
const create = vide.create

const function App()
	const page = usePage()
	
	return create 'Frame' {
		IgnoreGuiInset = true
	}	
end

return App
