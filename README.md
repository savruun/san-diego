# Sorcery

## How to

- Install packages
+ Add the package scope to wally.toml.
+ In the terminal use `lune run install`

- Serve the project with rojo
+ In the terminal run `lune run dev`

- Regenerate the sourcemap
+ In the terminal run `lune run sourcemap`

- Require a package
+ We use string requires here, for example requiring a package looks like `local WCS = require('@packages/wcs')`
+ To see all available packages check wally.toml, you should also have intellisense for the requires

- Sometimes I don't get intellisense requiring
+ If the intellisense somewhat works but sometimes disappears try using ctrl + space
+ If no auto-reccomendations show up try regenerating the sourcemap


## What-ifs

- The type of the package I required is an error type, what do I do?
+ This is usually due to Luau LSP's auto sourcemap regen not working.
+ In the terminal run `lune run sourcemap`.
+ If the issue occurs again repeat the command or using the command and restarting vscode.