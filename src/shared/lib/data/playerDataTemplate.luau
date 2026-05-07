const PLAYER_DATA_TEMPLATE = {
  cash = 0,
  
  temporaryPerks = {} :: { [string]: number },

  hotbar = {} :: { [string]: string },
  
  jailData = {
    jailed = false,
    timeLeft = 0,
    reason = '',
    jailedBy = ''
  }
}

return PLAYER_DATA_TEMPLATE
