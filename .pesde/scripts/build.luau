local fs = require('@lune/fs')
local process = require('@lune/process')
local regex = require('@lune/regex')

local cwd = process.cwd
local SRC_DIR = 'src'
local OUT_DIR = 'out'

if fs.isDir(OUT_DIR) then fs.removeDir(OUT_DIR) end
fs.writeDir(OUT_DIR)

local requirePatterns = {
	{
		'require%(([\'"`])@pkg/([^\'"`]+)[\'"`]%)',
		'require(\'@game/ReplicatedStorage/packages/%2\')',
	},

	{
		'require%(([\'"`])@spkg/([^\'"`]+)[\'"`]%)',
		'require(\'@game/ServerScriptService/packages/%2\')',
	},

	{
		'require%(([\'"`])@client/([^\'"`]+)[\'"`]%)',
		'require(\'@game/ReplicatedStorage/client/%2\')',
	},

	{
		'require%(([\'"`])@server/([^\'"`]+)[\'"`]%)',
		'require(\'@game/ServerScriptService/server/%2\')',
	},

	{
		'require%(([\'"`])@ui/([^\'"`]+)[\'"`]%)',
		'require(\'@game/ReplicatedStorage/client/interface/%2\')',
	},

	{
		'require%(([\'"`])@types/([^\'"`]+)[\'"`]%)',
		'require(\'@game/ReplicatedStorage/shared/types/%2\')',
	},

	{
		'require%(([\'"`])@shared/([^\'"`]+)[\'"`]%)',
		'require(\'@game/ReplicatedStorage/shared/%2\')',
	},
}

function walk(dir: string): { string }
	local results = {}

	for _, file in fs.readDir(dir) do
		local fullPath = dir .. '/' .. file

		if fs.isFile(fullPath) then
			if fullPath:match('%.lua$') or fullPath:match('%.luau$') then table.insert(results, fullPath) end
		elseif fs.isDir(fullPath) then
			local sub = walk(fullPath)

			for _, v in sub do
				table.insert(results, v)
			end
		end
	end

	return results
end

function transform(content: string)
	for _, patternPair in requirePatterns do
		local pattern: string = patternPair[1]
		local replacement: string = patternPair[2]

		content = content:gsub(pattern, replacement)
	end

	return content
end

local files = walk(cwd .. SRC_DIR)
local pathRegex = regex.new('/src/')
local fileRegex = regex.new('%.luau?$') -- matches .lua OR .luau at end
local dirRegex = regex.new('(.+)/[^/]+$')

for _, file in files do
	local outPath = pathRegex:replace(file, '/out/')

	local dirReCaptures = dirRegex:captures(outPath)
	if not dirReCaptures then continue end

	local capOne = dirReCaptures:get(1)
	if not capOne then continue end

	local dir = capOne.text
	if dir and not fs.isDir(dir) then fs.writeDir(dir) end

	local fileContent = fs.readFile(file)
	local transformed = transform(fileContent)

	if not fs.isFile(outPath) then fs.writeFile(outPath, transformed) end
end
