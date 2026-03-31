local fs = require('@lune/fs')
local process = require('@lune/process')
local stdio = require('@lune/stdio')

local results = {
	wally = process.exec('wally.exe', { 'install' }),
	sourcemap = process.exec('rojo.exe', { 'sourcemap', 'default.project.json', '--output', 'sourcemap.json' }),
	pkg_types = process.exec(
		'wally-package-types.exe',
		{ '--sourcemap', 'sourcemap.json', 'Packages/', if fs.isDir('ServerPackages/') then 'ServerPackages/' else nil }
	),
}

for i: number, v: process.ExecResult in pairs(results) do
	if v.ok then continue end
	stdio.write(`{stdio.color('red')}error({i}):{stdio.color('reset')} {v.stderr}`)
end

stdio.write(
	`{stdio.color('green')}info:{stdio.color('reset')} Successfully installed packages and generated their types`
)
