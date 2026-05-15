const PLAYER_DATA_TEMPLATE = require('@shared/data/playerDataTemplate')
const playerTypes = {}

export type PlayerData = typeof(PLAYER_DATA_TEMPLATE)

export type SafePlayerData = {
  cash: number,
  hotbar: { [string]: string },

  jailData: {
    jailed: boolean,
    timeLeft: number,
    reason: string,
    jailedBy: string
  }
}

return playerTypes
