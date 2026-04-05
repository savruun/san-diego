--!strict

const signal = require('@pkg/signal')
const Store = {}

export type Store<T> = {
	__signal: signal.Signal<T>,
	__value: T,

	subscribe: (self: Store<T>, callback: (T) -> ()) -> signal.Connection,
	get: (self: Store<T>) -> T,
	set: (self: Store<T>, value: T) -> (),
}

function Store.new<T>(initialValue: T)
	local self = setmetatable({} :: Store<T>, { __index = Store })

	self.__signal = signal.new()
	self.__value = initialValue

	return self
end

function Store.subscribe<T>(self: Store<T>, callback: (T) -> ()): signal.Connection
	return self.__signal:Connect(callback)
end

function Store.get<T>(self: Store<T>) return self.__value end

function Store.set<T>(self: Store<T>, value: T): ()
  self.__value = value
  self.__signal:Fire(value)
end

return Store
