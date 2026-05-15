local module = {}

export type PersistentAnticheatTrigger = {
	reason: string,
	timestamp: number,
	incidentId: string,
}

export type AnticheatTrigger = {
	timestamp: number,
	reason: string,
	expiration: number,
}

return module
