local M = {}
local rewind = require("rewind")
local config = rewind.config
local keymap = rewind.keymap
local util = rewind.util
local ui = rewind.ui

function M.setup()
	keymap.util.set_keymap("tasks", "n", { config.keymaps.select }, function()
		ui.util.prompt_toggle_window("prompt")
	end)
end

return M
