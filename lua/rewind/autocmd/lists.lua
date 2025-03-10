local M = {}
local rewind = require("rewind")
local autocmd = rewind.autocmd
local util = rewind.util
local command = rewind.command

function M.setup()
	local key = "lists"
	autocmd.util.set(key, { "CursorMoved" }, function()
		util.update_highlight(key)

		local _, current_list = util.get_cursor_content("lists")
		if current_list then
			util.set_var("current_list", current_list)
		end
	end)
end

return M
