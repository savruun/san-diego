local function map<K, V, U>(source: { [K]: V }, fn: (V, K) -> U)
	local result = {}

	for index, value in source do
		table.insert(result, fn(value, index))
	end

	return result
end

return map
