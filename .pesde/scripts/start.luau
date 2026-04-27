local process = require("@lune/process")
local task = require("@lune/task")

task.spawn(function() process.exec("rojo", { "serve", "build.project.json" }, { stdio = "inherit" }) end)

task.spawn(
	function() process.exec("watchexec", { "-r", "-e", "luau", "--", "pesde run build" }, { stdio = "inherit" }) end
)
