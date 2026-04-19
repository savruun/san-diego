const timer = {}

type Properties = { duration: number }
export type Timer = setmetatable<Properties, typeof({ __index = timer })>

function timer.new(duration: number): Timer
  local self = setmetatable({}, { __index = timer })
  
  self.duration = duration

  return self
end

function timer.update(self: Timer, delta: number)
  self.duration -= delta
end

function timer.isFinished(self: Timer)
  return self.duration <= 0
end

function timer.destroy(self: Timer)
  self.duration = nil
  setmetatable(self, nil)
end

return timer
