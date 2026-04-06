local process = require('@lune/process')
local stdio = require('@lune/stdio')

if process.os ~= 'windows' then
	stdio.write(`{stdio.color('red')}error:{stdio.color('reset')} this command is only compatible with windows\n`)
	return process.exit(1)
end

process.exec('powershell.exe', { 'start roblox-studio:' })

stdio.write(`{stdio.color('green')}info:{stdio.color('reset')} Successfully started studio protocol`)
