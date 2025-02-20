local M = {}
local rewind = require("rewind")
local config = rewind.config
local keymap = rewind.keymap
local ui = rewind.ui

function M.setup()
	local key = "help"
	keymap.util.set(key .. "_max", "n", { config.keymaps.back }, function()
		ui.util.toggle_window(key .. "_min")
		ui.util.toggle_window(key, "_max")
	end)

	keymap.util.set(key .. "_min", "n", { config.keymaps.back }, function()
		ui.util.toggle_window(key .. "_min")
		ui.util.toggle_window(key .. "_max")
	end)
end

return M
