const conch = require('@pkg/conch')

const SetdataCommand = conch.register('setdata', {
  description = 'Change a user\'s data schema.',
  permissions = { 'permission_name' },

  arguments = function() end,
  callback = function() end
})

return SetdataCommand