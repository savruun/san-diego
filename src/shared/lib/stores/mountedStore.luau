local Store = require('./Store')

local mountedStore = Store.new << { string } >> {}
return mountedStore
