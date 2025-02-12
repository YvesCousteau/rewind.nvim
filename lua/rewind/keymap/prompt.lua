local M = {}
local rewind = require("rewind")
local config = rewind.config
local keymap = rewind.keymap
local util = rewind.util
local ui = rewind.ui

function M.setup()
	keymap.util.set_keymap("prompt", "i", { config.keymaps.back }, function()
		ui.util.prompt_toggle_window("prompt")
	end)

	keymap.util.set_keymap("prompt", "i", { config.keymaps.select }, function()
		ui.util.prompt_toggle_window("prompt")
		-- should save in the file
	end)
end

return M
