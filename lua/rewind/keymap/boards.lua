local M = {}
local config = require("rewind.config")
local util = require("rewind.util")
local ui = require("rewind.ui.util")

function M.setup()
	local buf = util.buf.get_buffer("boards")
	util.set_keymap(buf, "n", config.keymaps.help, function()
		ui.toggle_window("help_min")
		-- ui.toggle_window("help_max")
	end)
end

return M
