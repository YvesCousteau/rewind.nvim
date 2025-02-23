local M = {}
local rewind = require("rewind")
local config = rewind.config
local keymap = rewind.keymap
local ui = rewind.ui

function M.setup()
	local key = "confirmation"
	keymap.util.set(key, "n", { config.keymaps.back }, function()
		ui.util.toggle_window(key)
	end)

	keymap.util.set(key, "n", { config.keymaps.select }, function()
		ui.util.toggle_window(key)
	end)
end

return M
