const paths = require('@shared/paths')

local pages = {}
for _, page in paths.interface.pages:GetChildren() do
  if not page:IsA('ModuleScript') then continue end
  pages[page.Name] = require(page) :: () -> Instance
end

local function getPages()
  return pages
end 

return getPages