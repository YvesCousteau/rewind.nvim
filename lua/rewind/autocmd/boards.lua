local M = {}
local rewind = require("rewind")
local autocmd = rewind.autocmd
local util = rewind.util
local command = rewind.command

function M.setup()
	local key = "boards"
	autocmd.util.set(key, { "CursorMoved" }, function()
		util.update_highlight(key)

		local _, current_board = util.get_cursor_content("boards")
		if current_board then
			util.set_var("current_board", current_board)
		end
	end)
end

return M
