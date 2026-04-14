const function lazyTable<T>(callback: (table: T) -> ()): T
	local table = {} :: any
	callback(table)

	return table
end

return lazyTable
