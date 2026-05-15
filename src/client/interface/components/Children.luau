local function Children(props: { [any]: any })
	local children: { [number]: GuiObject } = {}

	for i: any, v: any in props do
		if typeof(i) == 'number' then table.insert(children, v) end
	end

	return table.unpack(children)
end

return Children
