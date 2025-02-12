local M = {}
local rewind = require("rewind")
local config = rewind.config
local keymap = rewind.keymap
local util = rewind.util
local ui = rewind.ui

function M.setup()
	keymap.util.set_keymap("boards", "n", { config.keymaps.select }, function()
		if util.buf.is_buffer_empty("lists") then
			util.switch_window("lists")
		else
			ui.util.prompt_toggle_window("prompt")
		end
	end)
end

return M
