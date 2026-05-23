const Teams = game:GetService('Teams')

const TeamEnum = require('@enums/Team')
type TeamEnum = TeamEnum.TeamEnum

const teamData = require('@data/teamData')

const Signal = require('@lib/Signal')

const TeamService = {
	TeamChanged = Signal.new<<Player, string>>(),
}

function TeamService.start(self: self) end

function TeamService.setPlayerTeam(self: self, player: Player, teamName: keyof<typeof(teamData)>): ()
	local team = Teams:FindFirstChild(teamName)
	if not team then return end

	player.Team = team
	self.TeamChanged:Fire(player, teamName)
end

function TeamService.getPlayerTeam(self: self, player: Player): string?
	const team = player.Team
	if not team then return nil end

	return team.Name
end

function TeamService.__createTeams(self: self): ()
	for _, data in teamData do
		const team = Instance.new('Team', Teams)
		team.Name = data.Name
		team.TeamColor = data.Color
	end
end

export type self = typeof(TeamService)
return TeamService
