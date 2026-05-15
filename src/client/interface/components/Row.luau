const vide = require('@pkg/vide')
const create = vide.create

const Children = require('@ui/components/Children')

type Props = {
  size: UDim2?,
  position: UDim2?,
  anchor: Vector2,
  align: Enum.HorizontalAlignment?,
  padding: UDim?,

  [number]: GuiObject
}

local function Row(props: Props)
  return create 'Frame' {
    Size = props.size or UDim2.new(),
    Position = props.position or UDim2.new(),
    AnchorPoint = props.anchor or Vector2.zero,
    BackgroundTransparency = 1,

    create 'UIListLayout' {
      FillDirection = Enum.FillDirection.Horizontal,
      HorizontalAlignment = props.align,
      Padding = props.padding or UDim.new()
    },

    Children(props)
  }
end

return Row
