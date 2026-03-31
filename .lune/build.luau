local process = require('@lune/process')
local stdio = require('@lune/stdio')

process.exec('darklua.exe', { 'process', '--config', '.darklua.json', 'src/', 'out/' })

stdio.write(`{stdio.color('green')}info:{stdio.color('reset')} Successfully built the project with darklua`)
