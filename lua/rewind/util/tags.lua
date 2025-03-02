local M = {}
local rewind = require("rewind")
local util = rewind.util
local command = rewind.command

function M.reset_tags_color()
	command.list.tags.get_tags(function(buf, board, id, tag)
		local name = board.title .. "_tag_" .. tostring(id)
		local ns = util.get_var(name .. "_ns")
		if ns then
			vim.api.nvim_buf_clear_namespace(buf, ns, id - 1, 0)
		end
	end)
end

function M.init_tags_color()
	command.list.tags.get_tags(function(buf, board, id, tag)
		local name = board.title .. "_tag_" .. tostring(id)
		local ns = vim.api.nvim_create_namespace(name .. "_ns")
		if ns then
			util.set_var(name .. "_ns", ns)
			vim.api.nvim_set_hl(0, name, { fg = tag.color })
			vim.api.nvim_buf_add_highlight(buf, ns, name, id - 1, 0, -1)
		end
	end)
end

return M
