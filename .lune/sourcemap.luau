local process = require('@lune/process')
local stdio = require('@lune/stdio')

process.exec('rojo.exe', { 'sourcemap', 'default.project.json', '--output', 'sourcemap.json' })

stdio.write(`{stdio.color('green')}info:{stdio.color('reset')} Successfully generated sourcemap`)
