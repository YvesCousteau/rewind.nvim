local M = {}
local rewind = require("rewind")
local config = rewind.config
local keymap = rewind.keymap
local ui = rewind.ui

function M.setup()
	keymap.util.set("help_max", "n", { config.keymaps.back }, function()
		ui.help.toggle_window("help_min")
		ui.help.toggle_window("help_max")
	end)

	keymap.util.set("help_min", "n", { config.keymaps.back }, function()
		ui.help.toggle_window("help_min")
		ui.help.toggle_window("help_max")
	end)
end

return M
