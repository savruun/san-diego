--!strict

const paths = require('@shared/lib/paths')
const vide = require('@pkg/vide')
const pageStore = require('@shared/lib/stores/pageStore')

const effect = vide.effect
const cleanup = vide.cleanup

local pages = {}
for _, page in paths.interface.pages:GetChildren() do
	if not page:IsA('ModuleScript') then continue end
	pages[page.Name] = require(page) :: Frame
end

const function usePage()
  const page = vide.source(pages[pageStore:get() or ''])
  
  const connection = pageStore:subscribe(function(newPage: string?)
    page(pages[newPage or ''])
  end)


  cleanup(function()
    connection:Disconnect()
  end)

	return page()
end

return usePage
