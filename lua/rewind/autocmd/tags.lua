local M = {}
local rewind = require("rewind")
local autocmd = rewind.autocmd
local util = rewind.util
local command = rewind.command

function M.setup()
	local key = "tags"
	autocmd.util.set(key, { "CursorMoved" }, function()
		util.update_highlight(key)
	end)

	autocmd.util.set(key, { "WinClosed" }, function()
		command.list.tags.get_tags(function(buf, board, id, tag)
			local name = board.title .. "_tag_" .. tostring(id)
			local ns = util.get_var(name .. "_ns")
			if ns then
				vim.api.nvim_buf_clear_namespace(buf, ns, id - 1, 0)
			end
		end)
	end)
end

return M
