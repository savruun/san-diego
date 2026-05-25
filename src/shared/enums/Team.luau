const TeamEnum = table.freeze {
	FBI = 'Federal Buerea of Investigation',
	HLS = 'Homeland Security',
	USBP = 'United States Border Patrol',
	USA = 'United States Army',
	ST = 'State Trooper',
	Civilian = 'Civilian',
}

export type TeamEnum = typeof(TeamEnum)

return TeamEnum
