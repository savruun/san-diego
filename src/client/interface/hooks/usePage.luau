--!strict

local pageStore = require('@shared/lib/stores/pageStore')
local paths = require('@shared/paths')
local vide = require('@pkg/vide')

local cleanup = vide.cleanup

local pages = {}
for _, page in paths.interface.pages:GetChildren() do
	if not page:IsA('ModuleScript') then continue end
	pages[page.Name] = require(page) :: () -> Frame
end

local function usePage()
	local page = vide.source(pages[pageStore:get() or ''])

	local connection = pageStore:subscribe(function(newPage: string?) page(pages[newPage or '']) end)

	cleanup(function() connection:Disconnect() end)

	return page()
end

return usePage
