local M = {}
local rewind = require("rewind")
local util = rewind.util
local command = rewind.command

function M.init_tags_color()
	command.list.tags.get_tags(function(buf, board, id, tag)
		local name = board.title .. "_tag_" .. tostring(id)
		local ns = vim.api.nvim_create_namespace(name)
		if ns then
			vim.api.nvim_set_hl(0, name, { fg = tag.color })
			vim.api.nvim_buf_add_highlight(buf, ns, name, id - 1, 0, -1)
		end
	end)
end

return M
