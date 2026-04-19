const constants = {}

constants.fov = {
  default = 70,
  sprinting = 75
}

constants.walkspeed = {
  default = 16,
  sprinting = 20
}

constants.maxStamina = 100 -- % value
constants.sprintCooldown = 3 -- seconds

constants.stamina = {
  drainRate = 15, -- % per sec
  regenRate = 10 -- % per sec 
}

return constants
