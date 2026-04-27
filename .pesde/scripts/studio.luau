local process = require("@lune/process")

if process.os == "linux" then
	process.exec("flatpak", { "run", "org.vinegarhq.Vinegar" }, { stdio = "inherit " })
else
	process.exec("start", { "roblox-studio:" }, { stdio = "inherit" })
end
