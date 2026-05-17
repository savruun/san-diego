const Timer = {}

type Properties = { duration: number }
export type Timer = setmetatable<Properties, typeof({ __index = Timer })>

function Timer.new(duration: number): Timer
	local self = setmetatable({}, { __index = Timer })

	self.duration = duration

	return self
end

function Timer.update(self: Timer, delta: number)
	self.duration -= delta
end

function Timer.isFinished(self: Timer) return self.duration <= 0 end

function Timer.destroy(self: Timer)
	self.duration = nil
	setmetatable(self, nil)
end

return Timer
