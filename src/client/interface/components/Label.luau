const vide = require('@pkg/vide')
const create = vide.create

const Children = require('@ui/components/Children')

type Props = {
  color: Color3?,
  position: UDim2,
  size: UDim2,
  font: Enum.Font,
  text: string,
  scaled: boolean,

  [number]: GuiObject
}

local function Label(props: Props)
  return create 'TextLabel' {
    TextColor3 = props.color,
    BackgroundTransparency = 1,
    Size = props.size, Position = props.position,
    Font = props.font or Enum.Font.Arimo,
    Text = props.text,
    TextScaled = props.scaled,
    
    Children(props)
  }
end

return Label