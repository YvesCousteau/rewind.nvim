local M = {}
local rewind = require("rewind")
local config = rewind.config
local keymap = rewind.keymap
local ui = rewind.ui
local util = rewind.util

function M.setup()
	local key = "date_picker"
	keymap.util.set(key, "n", { config.keymaps.back }, function()
		ui.list.date_picker.close_window(key, true)
	end)

	keymap.util.set(key, "n", { config.keymaps.select }, function()
		ui.util.toggle_window(key)
	end)

	keymap.util.set(key, "n", { "+" }, function()
		util.date_picker.increment()
	end)

	keymap.util.set(key, "n", { "-" }, function()
		util.date_picker.decrement()
	end)
end

return M
