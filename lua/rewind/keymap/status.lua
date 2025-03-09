local M = {}
local rewind = require("rewind")
local config = rewind.config
local keymap = rewind.keymap
local ui = rewind.ui
local util = rewind.util

function M.setup()
	local key = "status"
	keymap.util.set(key, "n", { config.keymaps.back }, function()
		ui.list.status.close_window(key, true)
	end)

	keymap.util.set(key, "n", { config.keymaps.select }, function()
		ui.util.toggle_window(key)
	end)
end

return M
