-- Packages

const vide = require('@pkg/vide')
const charm = require('@pkg/charm')

const getComponents = require('@ui/util/getComponents')
const getPages = require('@ui/util/getPages')
const map = require('@ui/util/map')
const useAtom = require('@ui/hooks/useAtom')

const create = vide.create
const values = vide.values
const show = vide.show

const pages = getPages()
const components = getComponents()

const function App(page: charm.Atom<string?>, mountedComponents: charm.Atom<{ string }>)
	const mountedList = useAtom(mountedComponents)
	const pageName = useAtom(page)

	return create 'ScreenGui' {
		Name = 'VIDE_ROOT',
		ResetOnSpawn = false,
		IgnoreGuiInset = true,

		map(pages, function(_, currentName: string)
			return show(function() return currentName == pageName() end, pages[currentName])
		end),

		create 'Folder' {
			Name = 'components',
			values(mountedList, function(name: string) return components[name]() end),
		},
	}
end

return App
