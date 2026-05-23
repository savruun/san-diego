const TeamEnum = table.freeze {
	FBI = 'Federal Buerea of Investigation',
	HLS = 'Homeland Security',
	Civilian = 'Civilian',
}

export type TeamEnum = typeof(TeamEnum)

return TeamEnum
