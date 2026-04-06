-- Packages
local usePage = require('@client/interface/hooks/usePage')
local vide = require('@pkg/vide')
local create = vide.create

local function App()
	local page = usePage()

	return create 'ScreenGui' {
		IgnoreGuiInset = true,
		ResetOnSpawn = true,
		Name = 'VIDE_APP',

		page,
	}
end

return App
