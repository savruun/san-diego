local process = require('@lune/process')
local stdio = require('@lune/stdio')
local task = require('@lune/task')

process.env['ROBLOX_DEV'] = true

local programSuffix = if process.os == 'windows' then '.exe' else ''

local sourcemapProcess =
	process.create('rojo', { `sourcemap{programSuffix}`, 'default.project.json', '-o', 'sourcemap.json', '--watch' })
local darkluaProcess =
	process.create(`darklua{programSuffix}`, { 'process', '--config', '.darklua.json', '--watch', 'src/', 'out/' })
local rojoProcess = process.create(`rojo{programSuffix}`, { 'serve', 'build.project.json' })

local function checkOk(process: process.ChildProcess)
	local status = process:status()

	if status.ok then
		local stdout = process.stdout:read()
		if stdout then print(stdout) end
	else
		local stderr = process.stderr:read()
		if stderr then print(stderr) end

		process:kill()
	end
end

task.spawn(function()
	while task.wait(1) do
		checkOk(sourcemapProcess)
		checkOk(darkluaProcess)
		checkOk(rojoProcess)
	end
end)

stdio.write(`{stdio.color('green')}info:{stdio.color('reset')} Running dev server\n`)
