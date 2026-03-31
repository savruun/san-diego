local Signal = require('@packages/signal')

local page_store = {
	__page = nil :: string | nil,
	__changed = Signal.new(),
}

function page_store.set(self: self, page: string | nil): ()
	self.__page = page
	self.__changed:Fire(page)
end

function page_store.get(self: self): string | nil return self.__page end

function page_store.subscribe(self: self, callback: (string?) -> ()): Signal.Connection
	return self.__changed:Connect(callback)
end

type self = typeof(page_store)
return page_store
