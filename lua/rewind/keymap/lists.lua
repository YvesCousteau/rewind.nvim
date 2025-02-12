local M = {}
local rewind = require("rewind")
local config = rewind.config
local keymap = rewind.keymap
local util = rewind.util
local ui = rewind.ui

function M.setup()
	keymap.util.set_keymap("lists", "n", { config.keymaps.select }, function()
		if util.buf.is_buffer_empty("tasks") then
			util.switch_window("tasks")
		else
			ui.util.prompt_toggle_window("prompt")
		end
	end)
end

return M
