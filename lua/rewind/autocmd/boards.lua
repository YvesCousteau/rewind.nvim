local M = {}
local rewind = require("rewind")
local autocmd = rewind.autocmd
local util = rewind.util

function M.setup()
	local key = "boards"
	autocmd.util.set(key, { "CursorMoved" }, function()
		local line_id = vim.api.nvim_win_get_cursor(0)[1]
		local var = util.buf.get_var(key)
		print(var[line_id].title)
	end)
end

return M
