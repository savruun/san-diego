const vide = require('@pkg/vide')
const create = vide.create

const weaponTypes = require('@types/weapons')
const scopeIds = require('@shared/data/scopeIds')

type Props = {
  scopeType: weaponTypes.ScopeId
}

local function Scope(props: Props)
  return create 'ImageLabel' {
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.fromScale(1, 1),

    Image = scopeIds[props.scopeType],
    BackgroundTransparency = 1,

    create 'UIAspectRatioConstraint' {
      AspectRatio = 1
    }
  }
end

return Scope
