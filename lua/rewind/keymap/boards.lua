local M = {}
local rewind = require("rewind")
local config = rewind.config
local keymap = rewind.keymap
local util = rewind.util
local ui = rewind.ui

function M.setup()
	keymap.util.set("boards", "n", { config.keymaps.select }, function()
		if util.buf.is_empty("lists") then
			util.switch_window("lists")
		else
			ui.prompt.toggle_window("prompt")
		end
	end)

	keymap.util.set("boards", "n", { config.keymaps.back }, function()
		ui.util.close_all_window()
	end)
end

return M
