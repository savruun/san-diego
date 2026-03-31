local process = require('@lune/process')
local stdio = require('@lune/stdio')
local task = require('@lune/task')

process.env['ROBLOX_DEV'] = true

local sourcemap_process =
	process.create('rojo.exe', { 'sourcemap', 'default.project.json', '-o', 'sourcemap.json', '--watch' })
local darklua_process =
	process.create('darklua.exe', { 'process', '--config', '.darklua.json', '--watch', 'src/', 'out/' })
local rojo_process = process.create('rojo.exe', { 'serve', 'build.project.json' })

local function check_ok(process: process.ChildProcess)
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
		check_ok(sourcemap_process)
		check_ok(darklua_process)
		check_ok(rojo_process)
	end
end)

stdio.write(`{stdio.color('green')}info:{stdio.color('reset')} Running dev server\n`)
