const constants = {}

constants.FOV = {
  DEFAULT = 70,
  SPRINTING = 75
}

constants.WALKSPEED = {
  DEFAULT = 16,
  SPRINTING = 20
}

constants.MAX_STAMINA = 100 -- % value
constants.SPRINT_COOLDOWN = 3 -- seconds

constants.STAMINA = {
  DRAIN_RATE = 15, -- % per sec
  REGEN_RATE = 10 -- % per sec 
}

constants.GRAVITY_DAMPING = 0.5
constants.GRAVITY = Vector3.new(0, -workspace.Gravity * constants.GRAVITY_DAMPING, 0)

return constants
