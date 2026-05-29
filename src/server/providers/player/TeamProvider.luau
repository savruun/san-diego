const Teams = game:GetService('Teams')

const TeamEnum = require('@enums/Team')
type TeamEnum = TeamEnum.TeamEnum

const Signal = require('@lib/Signal')
const Dependency = require('@pkg/quill_dependencies')

const teamData = require('@data/teamData')
const net = require('@server/net')

const TeamProvider = {
	TeamChanged = Signal.new<<Player, string>>(),
	playerTeamCount = {} :: { [string]: number },
}

TeamProvider.CharacterProvider = Dependency.use(require('@ssingletons/player/CharacterProvider'))

function TeamProvider.start(self: self)
	net.RequestTeamChange.On(function(player, teamName)
		--// Todo: Add sanity check here to make sure player can actually use said team
		self:setPlayerTeam(player, teamName)

		-- Respawn them
		self.CharacterProvider:respawn(player)
	end)

	-- Initialize all team counts
	for teamName, _ in teamData do
		self.playerTeamCount[teamName] = 0
	end
end

function TeamProvider.setPlayerTeam(self: self, player: Player, teamName: keyof<typeof(teamData)>): ()
	const config = teamData[teamName]
	if not config then return end

	-- Do not allow more players on the team than allowed
	if config.maxPlayers and self.playerTeamCount[teamName] >= config.maxPlayers then return end

	-- Decrement the last team's count
	if player.Team then
		self.playerTeamCount[player.Team.Name] -= 1
	end

	const team = Teams:FindFirstChild(teamName)
	if not team then return end

	-- Increment the new team's count
	self.playerTeamCount[team.Name] += 1

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

	return teamData[team.Name]
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
