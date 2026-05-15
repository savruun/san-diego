const vide = require('@pkg/vide')
const create = vide.create
const source = vide.source
const spring = vide.spring

const Card = require('@ui/components/Card')
const GradientButton = require('@ui/components/GradientButton')
const Row = require('@ui/components/Row')
const Label = require('@ui/components/Label')
const ProgressBar = require('@ui/components/ProgressBar')

local ui_labs = require("../../../packages/ui_labs")

const abbreviateNumber = require('@ui/util/abbreviateNumber')

type SideButtonProps = {
	text: string,
	image: string?,
}

const DEFAULT_SIDE_BUTTON_SIZE = .37
const HOVER_SIDE_BUTTON_SIZE = .4

local function SideButton(props: SideButtonProps)
  local size = source(.37)
  local sizeSpring = spring(size, .3)

	return create 'TextButton' {
		Size = function()
      local currentSize = sizeSpring()
      return UDim2.fromScale(currentSize, currentSize)
    end,

    MouseEnter = function()
      size(HOVER_SIDE_BUTTON_SIZE)
    end,

    MouseLeave = function()
      size(DEFAULT_SIDE_BUTTON_SIZE)
    end,

		BackgroundColor3 = Color3.new(),
		BackgroundTransparency = 0.4,

		create 'UIAspectRatioConstraint' {
			AspectRatio = 1,
		},

		create 'UICorner' {
			CornerRadius = UDim.new(0.1),
		},

		create 'UIStroke' {
			Color = Color3.new(0.615686, 0.615686, 0.615686),
			Thickness = 2,
			Transparency = 0.35,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		},

		create 'TextLabel' {
			Text = props.text,
			Font = Enum.Font.ArialBold,
			TextColor3 = Color3.new(1, 1, 1),
			TextScaled = true,
			Size = UDim2.fromScale(1, 0.25),
			Position = UDim2.fromScale(0.5, 0.97),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,

			create 'UIStroke' {
				Thickness = 1,
			},
		},

		create 'ImageLabel' {
			Size = UDim2.fromScale(0.7, 0.7),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = props.image or 'rbxassetid://3926305904',
		},
	}
end

local function GunInfo()
  return Card {
    size = UDim2.fromScale(.15, .1),
    position = UDim2.fromScale(1, .99),
    anchorPoint = Vector2.new(1, 1),

    transparency = .4,

    create 'UIAspectRatioConstraint' {
      AspectRatio = 3.5
    },

    create 'UISizeConstraint' {
      MaxSize = Vector2.new(225, 225)
    },

    create 'TextLabel' {
      Name = 'GunName',

      Position = UDim2.fromScale(.05, .1),
      Size = UDim2.fromScale(.8, .25),

      BackgroundTransparency = 1,

      Text = 'Pistol',
      TextXAlignment = Enum.TextXAlignment.Left,
      Font = Enum.Font.ArimoBold,
      TextColor3 = Color3.new(1, 1, 1),
      TextScaled = true,
    },

    Row {
      align = Enum.HorizontalAlignment.Center,
      position = UDim2.fromScale(.5, .4),
      size = UDim2.fromScale(1, .2),
      anchor = Vector2.new(.5),
      padding = UDim.new(.05),
      
      Label {
        text = 'AUTO',
        font = Enum.Font.ArimoBold,
        color = Color3.new(1, 1, 1),
        scaled = true,
        size = UDim2.fromScale(.2, 1),
      },

      Label {
        text = 'SEMI',
        color = Color3.new(0.498039, 0.498039, 0.498039),
        scaled = true,
        size = UDim2.fromScale(.2, 1),
      },

      Label {
        text = 'BURST',
        color = Color3.new(0.498039, 0.498039, 0.498039),
        scaled = true,
        size = UDim2.fromScale(.2, 1),
      }
    },

    ProgressBar {
      name = 'Ammo',
      position = UDim2.fromScale(.5, .75),
      size = UDim2.fromScale(.9, .2),
      anchor = Vector2.new(.5)
    }
  }  
end

local function HUD()
	return create 'Frame' {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,

		create 'UIPadding' {
			PaddingRight = UDim.new(0, 5),
			PaddingTop = UDim.new(0, 5),
		},

		-- SIDEBAR
		Card {
			size = UDim2.fromScale(0.25, 0.45),
			position = UDim2.fromScale(1, 0.5),
			anchorPoint = Vector2.new(1, 0.5),
			transparency = 1,
			strokeTransparency = 1,

			create 'UIAspectRatioConstraint' {
				AspectRatio = 0.55,
			},

      create 'UISizeConstraint' {
        MaxSize = Vector2.new(300, 300)
      },

			create 'UIListLayout' {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0.03),
			},

			SideButton {
				text = 'Shop',
				image = 'rbxassetid://88312993212526',
			},

			SideButton {
				text = 'Teams',
				image = 'rbxassetid://135255732280184',
			},
		},

		-- TOP RIGHT CURRENCY BAR
		Card {
			size = UDim2.fromScale(0.2, 0.2),
			position = UDim2.fromScale(1, 0),
			anchorPoint = Vector2.new(1, 0),
			color = Color3.new(),
			transparency = 0.4,

			create 'UIAspectRatioConstraint' {
				AspectRatio = 4,
			},

			create 'UISizeConstraint' {
				MaxSize = Vector2.new(200, 200),
			},

			create 'UIListLayout' {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0.05),
			},

			create 'UIPadding' {
				PaddingLeft = UDim.new(0.05),
			},

			create 'ImageLabel' {
				Image = 'rbxassetid://104344287837531',
				Size = UDim2.fromScale(0.3, 0.8),
				BackgroundTransparency = 1,

				create 'UIAspectRatioConstraint' {
					AspectRatio = 1,
				},
			},

			create 'TextLabel' {
				Text = '$ 1,000',
				Font = Enum.Font.ArimoBold,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.fromScale(0, 0.5),
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0.5, 0.5),
				TextColor3 = Color3.new(0.223529, 0.788235, 0.533333),
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Left,
			},

			GradientButton {
				text = '+',
				font = Enum.Font.ArimoBold,
				size = UDim2.fromScale(0.4, 0.4),
				textScaled = true,
				cornerRadius = UDim.new(0.2),
				backgroundColor = ColorSequence.new(Color3.new(1, 0.913725, 0.14902), Color3.new(1, 0.627451, 0.137255)),
				color = Color3.new(1, 1, 1),
				strokeColor = Color3.new(1, 0.705882, 0.078431),
				strokeWidth = 2,
			},
		},

    GunInfo()
	}
end

local controls = {
  cash = 1000
}

return {
	vide = vide,
  controls = controls,
	story = function(props) return HUD(props) end,
}
