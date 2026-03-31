-- Packages
local react = require('@packages/react')

-- Hooks
local use_page = require('@client/interface/hooks/use_page')

-- React localizations
local e = react.createElement

-- Function component
local function App(props: { pages: { react.ReactNode } })
	local page = use_page()

	return e('ScreenGui', {
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		Name = 'App',
	}, {
		page and e(page),
	})
end

return App
