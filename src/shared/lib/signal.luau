const Signal = {}
Signal.__index = Signal

export type Signal<T...> = {
	Connect: (self: Signal<T...>, (T...) -> ()) -> RBXScriptConnection,
	Once: (self: Signal<T...>, (T...) -> ()) -> RBXScriptConnection,
	Fire: (self: Signal<T...>, T...) -> (),

  __event: BindableEvent
}

function Signal.new<T...>(): Signal<T...>
	local self = setmetatable({}, Signal)
  self.__event = Instance.new('BindableEvent')
	return self
end

function Signal.Connect<T...>(self: Signal<T...>, callback: (T...) -> ()): RBXScriptConnection
  return self.__event.Event:Connect(callback)
end

function Signal.Once<T...>(self: Signal<T...>, callback: (T...) -> ()): RBXScriptConnection
  return self.__event.Event:Once(callback)
end

function Signal.Fire<T...>(self: Signal<T...>, ...: T...)
  self.__event:Fire(...)
end

return Signal
