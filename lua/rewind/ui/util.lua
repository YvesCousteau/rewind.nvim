local M = {}
local util = require("rewind.util")

function M.toggle_window(key)
	local is_visible = util.toggle_visiblity(key)
	if is_visible == "false" then
		util.win.init_window(key)
	else
		util.win.close_window(key)
	end
end

return M
