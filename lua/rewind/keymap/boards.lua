local M = {}
local rewind = require("rewind")
local config = rewind.config
local util = rewind.util

function M.setup()
	local buf = util.buf.get_buffer("boards")
	if buf then
		util.set_keymap(buf, "n", config.keymaps.help, function()
			util.win.toggle_window("help_min")
			util.win.toggle_window("help_max")
		end)
	end
end

return M
