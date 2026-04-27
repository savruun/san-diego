local fs = require("@lune/fs")
local process = require("@lune/process")

local SRC_DIR = process.cwd .. "src/"
local OUT_DIR = process.cwd .. "out/"

if fs.isDir(OUT_DIR) then fs.removeDir(OUT_DIR) end
fs.writeDir(OUT_DIR)

local requirePatterns: { { string } } = {
	{ "require%((['\"`])@pkg/([^'\"`]+)['\"`]%)", "require('@game/ReplicatedStorage/packages/%2')" },
	{ "require%((['\"`])@spkg/([^'\"`]+)['\"`]%)", "require('@game/ServerScriptService/packages/%2')" },
	{ "require%((['\"`])@ssingletons/([^'\"`]+)['\"`]%)", "require('@game/ServerScriptService/server/providers/%2')" },
	{ "require%((['\"`])@csingletons/([^'\"`]+)['\"`]%)", "require('@game/ReplicatedStorage/client/providers/%2')" },
	{ "require%((['\"`])@lib/([^'\"`]+)['\"`]%)", "require('@game/ReplicatedStorage/shared/lib/%2')" },
	{ "require%((['\"`])@client/([^'\"`]+)['\"`]%)", "require('@game/ReplicatedStorage/client/%2')" },
	{ "require%((['\"`])@server/([^'\"`]+)['\"`]%)", "require('@game/ServerScriptService/server/%2')" },
	{ "require%((['\"`])@ui/([^'\"`]+)['\"`]%)", "require('@game/ReplicatedStorage/client/interface/%2')" },
	{ "require%((['\"`])@types/([^'\"`]+)['\"`]%)", "require('@game/ReplicatedStorage/shared/types/%2')" },
	{ "require%((['\"`])@shared/([^'\"`]+)['\"`]%)", "require('@game/ReplicatedStorage/shared/%2')" },
}

local function walk(dir: string): { string }
	local results = {}

	for _, entry in fs.readDir(dir) do
		local fullPath = dir .. entry

		if fs.isDir(fullPath) then
			local sub = walk(fullPath .. "/")
			table.move(sub, 1, #sub, #results + 1, results)
		elseif fullPath:match("%.luau?$") then
			table.insert(results, fullPath)
		end
	end

	return results
end

local function transform(content: string): string
	for _, pair in requirePatterns do
		content = content:gsub(pair[1], pair[2])
	end
	return content
end

local function ensureDir(path: string)
	if not fs.isDir(path) then fs.writeDir(path) end
end

for _, file in walk(SRC_DIR) do
	local outPath = OUT_DIR .. file:sub(#SRC_DIR + 1)
	local outDir = outPath:match("(.+)/[^/]+$")

	if outDir then ensureDir(outDir) end

	fs.writeFile(outPath, transform(fs.readFile(file)))
end
