local M = {}
local rewind = require("rewind")
local autocmd = rewind.autocmd

function M.setup()
	local key = "boards"
	autocmd.util.set(key, { "CursorMoved" }, function()
		local line_id = vim.api.nvim_win_get_cursor(0)[1]
		print(line_id)
		-- local uuid = uuid_map[line]
		-- if uuid then
		-- 	print("Selected UUID: " .. uuid)
		-- end
	end)
end

return M
