local M = {}
local rewind = require("rewind")
local config = rewind.config
local util = rewind.util
local ui = rewind.ui

function M.toggle_window(key)
	local is_visible = util.win.toggle_visiblity(key)
	print(key .. " |> " .. is_visible)
	if is_visible == "false" then
		util.win.close_window(key)
	else
		M.init_window(key)
	end
end

return M
