const vide = require('@pkg/vide')
const create = vide.create
const e = vide.batch
type Props = {
  name: string?,
  size: UDim2?,
  position: UDim2?,
  anchor: Vector2?
}

local function ProgressBar(props: Props)
  return create 'Frame' {
    Size = props.size or UDim2.new(),
    Position = props.position or UDim2.new(),
    AnchorPoint = props.anchor or Vector2.zero,

    --BackgroundColor3 = Color3.new(),
    BackgroundTransparency = 1,

    create 'UIStroke' {
      Thickness = 1,
      Color = Color3.new(1, 1, 1)
    },

    create 'UIPadding' {
      PaddingBottom = UDim.new(0, 2),
      PaddingLeft = UDim.new(0, 4),
      PaddingRight = UDim.new(0, 4),
      PaddingTop = UDim.new(0, 2)
    },

    create 'UIListLayout' {
      HorizontalAlignment = Enum.HorizontalAlignment.Left,
      VerticalAlignment = Enum.VerticalAlignment.Center,
      FillDirection = Enum.FillDirection.Horizontal,
      Padding = UDim.new(.01)
    },

    create 'Frame' {
      Size = UDim2.fromScale(.08, .9),
    },

    create 'Frame' {
      Size = UDim2.fromScale(.08, .9),
    },

    create 'Frame' {
      Size = UDim2.fromScale(.08, .9),
    },

    create 'Frame' {
      Size = UDim2.fromScale(.08, .9),
    },

    create 'Frame' {
      Size = UDim2.fromScale(.08, .9),
    },

    create 'Frame' {
      Size = UDim2.fromScale(.08, .9),
    },

    create 'Frame' {
      Size = UDim2.fromScale(.08, .9),
    },

    create 'Frame' {
      Size = UDim2.fromScale(.08, .9),
    },

    create 'Frame' {
      Size = UDim2.fromScale(.08, .9),
    },

    create 'Frame' {
      Size = UDim2.fromScale(.08, .9),
    },

    create 'Frame' {
      Size = UDim2.fromScale(.08, .9),
    }
  }
end

return ProgressBar