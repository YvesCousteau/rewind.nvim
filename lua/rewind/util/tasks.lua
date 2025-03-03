local M = {}
local rewind = require("rewind")
local util = rewind.util
local command = rewind.command

function M.init_tags_color()
	local _, board = util.get_cursor_content("boards")
	local _, list = util.get_cursor_content("lists")
	local buf = util.buf.get("tasks")
	local lenght_tag_icon = 2

	if list and board and buf then
		command.list.tasks.get(list, nil, function(title, state, date, tags, id)
			local name = util.buf.get_line("tasks", id)
			local ns = vim.api.nvim_create_namespace(string.format("%s_%s_%s_%d", board.title, list.title, title, id))
			if name and ns then
				local start = (#name - ((#tags + 1) * lenght_tag_icon))
				for id_tag, tag in ipairs(tags) do
					local highlight_name = string.format("%s_%s", board.title, tag.title)
					vim.api.nvim_set_hl(0, highlight_name, { fg = tag.color })
					local start_tag = start + (lenght_tag_icon * (id_tag - 1))
					vim.api.nvim_buf_add_highlight(
						buf,
						ns,
						highlight_name,
						id - 1,
						start_tag,
						start_tag + lenght_tag_icon
					)
				end
			end
		end)
	end
end

return M
