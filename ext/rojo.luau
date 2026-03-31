--!strict
local fs = require('@lune/fs')
local serde = require('@lune/serde')

local rojo = {}

type InputTree = { [string]: InputTree | string }
type RojoNode = { [string]: RojoNode } | { ['$path']: string } | { ['$className']: string }

local function compile_tree(tree: InputTree | string, srcDir: string, outDir: string): (RojoNode, RojoNode)
	if typeof(tree) == 'table' then
		local src_result: { [string]: any } = {}
		local build_result: { [string]: any } = {}

		for k, v in pairs(tree) do
			if k == '$className' then
				src_result[k] = v
				build_result[k] = v
			else
				local src, build = compile_tree(v, srcDir, outDir)
				src_result[k] = src
				build_result[k] = build
			end
		end

		return src_result, build_result
	end

	if typeof(tree) ~= 'string' then error('Invalid tree node') end

	-- alias expansion
	if tree:sub(1, 1) == '@' then
		local path = tree:sub(2)

		return { ['$path'] = srcDir .. '/' .. path }, { ['$path'] = outDir .. '/' .. path }
	end

	-- normal path string
	return { ['$path'] = tree }, { ['$path'] = tree }
end

--[[
  Serializes a Rojo project table
  @param project The project table to serialize.
]]
function rojo.project(project: Project)
	local src_tree, build_tree =
		compile_tree(project.tree :: InputTree, project.source_directory, project.compiled_directory or 'out')

	local src_project = {
		['$className'] = 'DataModel',
	}

	local build_project = {
		['$className'] = 'DataModel',
	}

	for i, v in src_tree do
		src_project[i] = v
	end

	for i, v in build_tree do
		build_project[i] = v
	end

	return {
		source_tree = {
			name = project.name,
			tree = src_project,
		},
		build_tree = {
			name = project.name,
			tree = build_project,
		},

		__tree = project.tree,
	}
end

function rojo.build(project: ProjectTree)
	if project.build_tree then fs.writeFile('build.project.json', serde.encode('json', project.build_tree)) end
	fs.writeFile('default.project.json', serde.encode('json', project.source_tree))
end

function rojo.create(service: Service): ServiceChildren
	return function(children: Dict)
		local result = {
			['$className'] = service,
		}

		for k, v in pairs(children) do
			result[k] = v
		end

		return result
	end
end

type Dict<T1 = string, T2 = string> = { [T1]: T2 }
type ServiceChildren = (children: { [string]: any }) -> Dict

type Service =
	| 'StarterPlayer'
	| 'ReplicatedStorage'
	| 'ReplicatedFirst'
	| 'ServerScriptService'
	| 'ServerStorage'
	| 'Workspace'
	| 'Lighting'
	| 'SoundService'
	| 'TestService'
	| 'StarterPlayerScripts'
	| 'StarterCharacterScripts'

export type Project = {
	compiled_directory: string?,
	source_directory: string,
	tree: Dict<Service, Dict>,
	name: string,
}

export type ProjectTree = { source_tree: Dict, build_tree: Dict?, __tree: Dict<Service, Dict> }

return rojo
