local process = require('@lune/process')
local stdio = require('@lune/stdio')

process.exec('powershell.exe', { 'start roblox-studio:' })

stdio.write(`{stdio.color('green')}info:{stdio.color('reset')} Successfully started studio protocol`)
