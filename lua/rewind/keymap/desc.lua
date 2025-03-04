local M = {}
local rewind = require("rewind")
local config = rewind.config
local keymap = rewind.keymap
local util = rewind.util
local ui = rewind.ui

function M.setup()
	local key = "desc"
	keymap.util.set(key, "n", { config.keymaps.back }, function()
		ui.list.prompt.close_window(key, true)
	end)

	keymap.util.set(key, "i", { config.keymaps.back }, function()
		ui.list.prompt.close_window(key, true)
	end)

	keymap.util.set(key, "i", { config.keymaps.select }, function()
		ui.util.toggle_window(key)
	end)
end

return M
