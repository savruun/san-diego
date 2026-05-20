export type self<T> = {
	debounce: number,
	__hashmap: { [T]: number },

	new: (debounce: number) -> self<T>,
	set: (self: self<T>, key: T) -> (),
	clear: (self: self<T>, key: T) -> (),
	get: (self: self<T>, key: T) -> boolean,
}

const Debounce = {}
Debounce.__index = Debounce

function Debounce.new<T>(debounce: number): self<T>
	local self = setmetatable({} :: self<T>, Debounce)

	self.debounce = debounce
	self.__hashmap = {}

	return self
end

--[[
  Set a debounce for a key.
  @param key The key to set the debounce for.
]]
function Debounce.set<T>(self: self<T>, key: T): () self.__hashmap[key] = os.clock() end

--[[
  Gets whether a debounce is active or not.
  @param key The key to check.
  @returns Whether or not the key is on debounce.
]]
function Debounce.get<T>(self: self<T>, key: T): boolean
	local lastUsed = self.__hashmap[key] or 0
	return os.clock() - lastUsed < self.debounce
end

--[[
  Clears a key from the debounc registry.
  @param key The key to clear from the registry.
]]
function Debounce.clear<T>(self: self<T>, key: T) self.__hashmap[key] = nil end

return Debounce
