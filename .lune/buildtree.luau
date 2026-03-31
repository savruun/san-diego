local stdio = require('@lune/stdio')

local project = require('../rojo-project')
local rojo = require('@ext/rojo')

rojo.build(project)

stdio.write(`{stdio.color('green')}info:{stdio.color('reset')} Successfully generated Rojo project file(s)`)
