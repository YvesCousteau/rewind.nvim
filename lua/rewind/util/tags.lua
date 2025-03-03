local M = {}
local rewind = require("rewind")
local util = rewind.util
local command = rewind.command

function generate_color()
	local r = math.random(0, 255)
	local g = math.random(0, 255)
	local b = math.random(0, 255)
	return string.format("#%02X%02X%02X", r, g, b)
end

function M.init_tags_color()
	command.list.tags.get(nil, function(buf, board, id, tag)
		local name = board.title .. "_tag_" .. tostring(id)
		local ns = vim.api.nvim_create_namespace(name)
		if ns then
			vim.api.nvim_set_hl(0, name, { fg = tag.color })
			vim.api.nvim_buf_add_highlight(buf, ns, name, id - 1, 0, -1)
		end
	end)
end

return M
