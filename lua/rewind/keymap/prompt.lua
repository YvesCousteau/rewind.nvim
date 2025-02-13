local M = {}
local rewind = require("rewind")
local config = rewind.config
local keymap = rewind.keymap
local util = rewind.util
local ui = rewind.ui

function M.setup()
	keymap.util.set("prompt", "n", { config.keymaps.back }, function()
		ui.prompt.toggle_window("prompt")
	end)

	keymap.util.set("prompt", "i", { config.keymaps.back }, function()
		ui.prompt.toggle_window("prompt")
	end)

	keymap.util.set("prompt", "i", { config.keymaps.select }, function()
		ui.prompt.toggle_window("prompt")
	end)
end

return M
