const scopeIds = require('@shared/data/scopeIds')

local module = {}

export type ScopeId = keyof<typeof(scopeIds)>

return module
