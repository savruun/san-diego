const Conch = require('@pkg/conch')

const SetdataCommand = Conch.register('setdata', {
  description = 'Change a user\'s data schema.',
  permissions = { 'permission_name' },

  arguments = function() end,
  callback = function() end
})

return SetdataCommand