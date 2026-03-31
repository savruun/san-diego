local paths = require('@shared/lib/paths')
local react = require('@packages/react')
local page_store = require("@shared/lib/stores/page_store")

local pages = {}
for _, page in paths.interface.pages:GetChildren() do
	if not page:IsA('ModuleScript') then continue end
	pages[page.Name] = require(page)
end

local function use_page(): react.FC<any>?
	local page, set_page = react.useState<<react.FC<any> | nil>>(function()
    return pages[page_store.get() or '']
	end)

  react.useEffect(function()
    local connection = page_store:subscribe(function(new_page: string?)
      set_page(pages[new_page or ''])
    end)

    return function()
      connection:Disconnect()
    end
  end, {})

	return page
end

return use_page
