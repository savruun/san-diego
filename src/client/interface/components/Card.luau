const vide = require('@pkg/vide')
const create = vide.create

const Children = require('@ui/components/Children')

type Props = {
  color: Color3?,
  transparency: number?,
  strokeTransparency: number?,
  size: UDim2,
  position: UDim2,
  anchorPoint: Vector2,
  [number]: GuiObject
}

local function Card(props: Props)
  return create 'Frame' {
    BackgroundColor3 = props.color or Color3.new(),
    BackgroundTransparency = props.transparency or 0.5,
    Size = props.size,
    Position = props.position,
    AnchorPoint = props.anchorPoint,

    create 'UICorner' {
      CornerRadius = UDim.new(0.05)
    },

    create 'UIStroke' {
      Color = Color3.new(0.580392, 0.580392, 0.580392),
      Thickness = 2,
      Transparency = props.strokeTransparency or 0.35,
      ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    },

    Children(props)
  }
end


return Card
