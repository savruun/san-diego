const vide = require('@pkg/vide')
const create = vide.create

type Props = {
  shadowType: 'Border' | 'Text',
  transparency: number?, offset: UDim2?, color: Color3?,
}

local function UIShadow(props: Props)
  if props.shadowType == 'Border' then
    return create 'Frame' {
      AnchorPoint = Vector2.new(.5, .5),
      Position = UDim2.fromScale(.5, .5) + props.offset or UDim2.new(),
      Size = UDim2.fromScale(1, 1),
      BackgroundColor3 = props.color or Color3.new(0, 0, 0),
      BackgroundTransparency = props.transparency or .8,
      ZIndex = -1,
    }
  else
    --// TODO: Make text shadow.
    return create 'TextLabel' {

    }
  end
end

return UIShadow
