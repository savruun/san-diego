const components = require('@pkg/quill_rblx_components')

-- Component Class
local Gun = {}
Gun.__index = Gun

type GunProperties = { }
export type self = setmetatable<GunProperties, typeof(Gun)>

-- Runs when the component is bound to an Instance
function Gun.init(self: self)
end

-- Runs when the Instance is destroyed
function Gun.destroy(self: self)
end


-- Quill component wrapper
local GunComponent = {}

-- Contains info such as filters
GunComponent.info = components.info {
  is = components.singleton('Tool'),
  tag = components.singleton('Gun')
}

-- Ran when the Component is constructing a new class instance
function GunComponent:new(data: components.CreationData<typeof(GunComponent.info)>)
  local instance = setmetatable({}, Gun)

  return instance
end

return GunComponent
