local process = require('@lune/process')
local stdio = require('@lune/stdio')

local programSuffix = if process.os == 'windows' then '.exe' else ''

process.exec(`rojo{programSuffix}`, { 'sourcemap', 'default.project.json', '--output', 'sourcemap.json' })

stdio.write(`{stdio.color('green')}info:{stdio.color('reset')} Successfully generated sourcemap`)
