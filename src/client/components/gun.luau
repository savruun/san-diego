--!strict

const components = require("@pkg/quill_rblx_components")
const dependency = require("@pkg/quill_dependencies")

const trove = require("@pkg/trove")
local ezinput = require("@pkg/ezinput")

const getAimDirection = require("@shared/lib/getAimDirection")
const net = require("@client/net")

-- Component Class
const Gun = {}
Gun.__index = Gun

type GunProperties = {
  instance: Tool,
  handle: BasePart,
  tip: Attachment,
  trove: trove.Trove,
  input: ezinput.ContextBuilder,
  equippedTrove: trove.Trove?
}

export type self = setmetatable<GunProperties, typeof(Gun)>


const CombatProvider = require("@csingletons/combat/CombatProvider")

-- Runs when the component is bound to an Instance
function Gun.init(self: self): ()
  -- When the gun is destroyed, cleanup the trove
  self.trove:AttachToInstance(self.instance)

  self.trove:Add(self.instance.Equipped:Connect(function()
    self.equippedTrove = self.trove:Extend()
    self.input = ezinput.context("gun")

    self:__attachInput()
  end))

  self.trove:Add(self.instance.Unequipped:Connect(function()
    if self.equippedTrove then
      self.equippedTrove:Clean()
    end
  end))
end

-- Runs when the Instance is destroyed
function Gun.destroy(self: self): ()
  self.trove:Clean()
end


function Gun.fire(self: self): ()
  local aimDirection = getAimDirection()

  -- Renders a predicted shot
  CombatProvider:renderBullet({
    position = self.tip.WorldPosition,
    origin = self.tip,
    direction = aimDirection,
    velocity = 100
  })

  net.FireGun.Fire({
    position = self.tip.WorldPosition,
    type = "test"
  })
end

function Gun.reload(self: self): ()
  print("reload")
end

function Gun.patrol(self: self): ()
  print("patrol arms")
end

function Gun.__attachInput(self: self): ()
  self.input:action("fire"):bind(Enum.KeyCode.MouseLeftButton):action():onPressed(function()
    self:fire()
  end)

  self.input:action("reload"):bind(Enum.KeyCode.R):action():onPressed(function()
    self:reload()
  end)

  self.input:action("patrol"):bind(Enum.KeyCode.F):action():onPressed(function()
    self:patrol()
  end)

  if not self.equippedTrove then
    return
  end

  self.equippedTrove:Add(function()
    self.input:destroy()
  end)
end

-- Quill component wrapper
const GunComponent = {}

-- Contains info such as filters
GunComponent.info = components.info {
  is = components.singleton("Tool"),
  tag = components.singleton("Gun"),

  children = {
    Handle = components.child("BasePart"),
    Tip = components.child("Attachment")
  }
}

-- Ran when the Component is constructing a new class instance
function GunComponent:new(data: components.CreationData<typeof(GunComponent.info)>): self
  local gun = setmetatable({}, Gun) :: self

  gun.instance = data.instance :: Tool
  gun.handle = data.children.Handle
  gun.tip = data.children.Tip

  gun.trove = trove.new()

  return gun
end

return GunComponent
