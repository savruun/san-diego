const vide = require('@pkg/vide')
const DeathScreen = require('@ui/pages/DeathScreen')

local controls = {
  KilledBy = 'savruun',
  KilledWith = 'Pistol',
  EnemyTeam = 'Neutral'
}

local story = {
  vide = vide,
  controls = controls,
  story = function(props)
    return DeathScreen()
  end
}

return story
