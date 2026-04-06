local function lazyTable<T>(callback: (table: T) -> ()): T
	local table = {} :: T
	callback(table)
	return table
end

return lazyTable
