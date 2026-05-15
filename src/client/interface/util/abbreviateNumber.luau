const SUFFIXES = { '', 'k', 'm', 'b', 't', 'qa', 'qi' }

local function abbreviateNumber(num: number): string
  local absNum = math.abs(num)

  if absNum < 1000 then
    return tostring(num)
  end

  local suffixIndex = math.floor(math.log10(absNum) / 3)
  local suffix = SUFFIXES[suffixIndex + 1] or ('e' .. (suffixIndex * 3))

  local shortened = num / (10 ^ (suffixIndex * 3))

	local formatted = shortened % 1 == 0
		and string.format("%.0f", shortened)
		or string.format("%.1f", shortened)

	return formatted .. suffix
end

return abbreviateNumber
