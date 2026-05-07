const charm = require('@pkg/charm')
const vide = require('@pkg/vide')

const source = vide.source
const subscribe = charm.subscribe
const cleanup = vide.cleanup

local function useAtom<T>(atom: charm.Atom<T>): vide.Source<T>
  local src = source(atom())

  local disconnect = subscribe(atom, function(state)
    src(state)
  end)

  cleanup(function()
    disconnect()
  end)

  return src
end


return useAtom
