const vide = require('@pkg/vide')
const Scope = require('@ui/components/Scope')

return {
	vide = vide,
	story = function(props) return Scope({ scopeType = 'genericSniper' }) end,
}
