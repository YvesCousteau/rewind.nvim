local M = {}
local rewind = require("rewind")
local config = rewind.config
local keymap = rewind.keymap
local ui = rewind.ui

function M.setup()
	keymap.util.set_keymap("boards", "n", config.keymaps.help, function()
		ui.util.toggle_window("help_min")
		ui.util.toggle_window("help_max")
	end)
end

return M
