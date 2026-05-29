const Players = game:GetService('Players')
const player = Players.LocalPlayer

const vide = require('@pkg/vide')
const uiLabs = require('@pkg/ui_labs')
const trove = require('@pkg/trove')

const teamData = require('@data/teamData')

const TitledPanel = require('@ui/components/TitledPanel')
const Card = require('@ui/components/Card')
const Label = require('@ui/components/Label')
const Pill = require('@ui/components/Pill')
const Button = require('@ui/components/Button')

const map = require('@ui/util/map')
const create = vide.create
const source = vide.source
const cleanup = vide.cleanup
const show = vide.show

const theme = require('@ui/theme')

local function TeamCard(props: { team: teamData.TeamData })
	const displayName = if props.team.name:len() < 20 then props.team.name else props.team.acronym
	local currentPlayers = source(0)
	local isCurrentTeam = source(player.Team and player.Team.Name == props.team.name)

	const connectionTrove = trove.new()

	connectionTrove:Add(Players.PlayerAdded:Connect(function(plr)
		const playerTrove = connectionTrove:Extend()

		playerTrove:Add(plr:GetPropertyChangedSignal('Team'):Connect(function(...)
			if plr.Team.Name == props.team.name then currentPlayers(currentPlayers() + 1) end
		end))
	end))

	connectionTrove:Add(Players.PlayerRemoving:Connect(function(plr)
		if plr.Team.Name == props.team.name then currentPlayers(currentPlayers() - 1) end
	end))

	for _, player in Players:GetPlayers() do
		if not player.Team or player.Team.Name ~= props.team.Name then continue end
		currentPlayers(currentPlayers() + 1)
	end

	-- When the team of the local player changes update this var
	connectionTrove:Add(
		player
			:GetPropertyChangedSignal('Team')
			:Connect(function() isCurrentTeam(player.Team and player.Team.Name == props.team.name) end)
	)

	cleanup(function() connectionTrove:Clean() end)

	return Card {
		size = UDim2.fromScale(0.27, 0.21),
		transparency = 0,
		color = theme.coal,
		corner = UDim.new(0.1),

		strokeColor = function() return isCurrentTeam() and theme.successBorder or theme.ashBorder end,

		strokeWidth = 1,
		order = if props.team.order then props.team.order.gui or 0 else nil,

		create 'UIAspectRatioConstraint' {
			AspectRatio = 0.7,
		},

		create 'UISizeConstraint' {
			MaxSize = Vector2.new(math.huge, 280),
		},

		Label {
			text = displayName,
			scaled = true,
			color = theme.text,
			size = UDim2.fromScale(0.8, 0.09),
			position = UDim2.fromScale(0.5, 0.05),
			anchor = Vector2.new(0.5),
		},

		Pill {
			Label {
				text = function()
					const count = currentPlayers()
					return if props.team.maxPlayers then `{count}/{props.team.maxPlayers}` else count
				end,

				scaled = true,
				size = UDim2.fromScale(1, 0.9),
				position = UDim2.fromScale(0.5, 0.5),
				anchor = Vector2.new(0.5, 0.5),
				color = theme.text,
			},
		},

		vide.show(
			isCurrentTeam,
			Button {
				strokeWidth = 1.5,
				padding = UDim.new(0, 5),
				position = UDim2.fromScale(0.5, 0.8),

				color = ColorSequence.new(Color3.new(0.396078, 0.721569, 0.407843), Color3.new(0.12549, 0.301961, 0.219608)),

				strokeColor = Color3.new(0.14902, 0.329412, 0.164706),
				text = 'Join',
			}
		),
	}
end

local function TeamSelect()
	return TitledPanel {
		text = 'CHOOSE TEAM',
		icon = 'rbxassetid://122316294483673',

		create 'ScrollingFrame' {
			Size = UDim2.fromScale(0.97, 0.91),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,

			create 'UIPadding' {
				PaddingTop = UDim.new(0, 10),
			},

			create 'UIListLayout' {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,

				Padding = UDim.new(0, 15),
				Wraps = true,
			},

			map(
				teamData,
				function(value: teamData.TeamData, index: string)
					return TeamCard {
						team = value,
					}
				end
			),
		},
	}
end

local controls = {
	cash = 1000,
}

return {
	vide = vide,
	controls = controls,
	story = function() return TeamSelect() end,
}
