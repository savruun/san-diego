local process = require("@lune/process")

process.exec("blink", { "net.blink" }, { stdio = "inherit" })
