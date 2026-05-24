const Teams = game:GetService('Teams')

const TeamEnum = require('@enums/Team')
type TeamEnum = TeamEnum.TeamEnum

const teamData = require('@data/teamData')

const Signal = require('@lib/Signal')

const TeamProvider = {
	TeamChanged = Signal.new<<Player, string>>(),
}

function TeamProvider.start(self: self) end

function TeamProvider.setPlayerTeam(self: self, player: Player, teamName: keyof<typeof(teamData)>): ()
	local team = Teams:FindFirstChild(teamName)
	if not team then return end

	player.Team = team
	self.TeamChanged:Fire(player, teamName)
end

function TeamProvider.getPlayerTeam(self: self, player: Player): string?
	const team = player.Team
	if not team then return nil end

	return team.Name
end

function TeamProvider.getTeamData(self: self, player: Player): teamData.TeamData?
	const team = player.Team
	if not team then return nil end

	return teamData[player.Team]
end

function TeamProvider.__createTeams(self: self): ()
	for _, data in teamData do
		const team = Instance.new('Team', Teams)
		team.Name = data.Name
		team.TeamColor = data.Color
	end
end

export type self = typeof(TeamProvider)
return TeamProvider
