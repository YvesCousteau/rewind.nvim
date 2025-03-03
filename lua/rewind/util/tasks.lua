local M = {}
local rewind = require("rewind")
local util = rewind.util
local command = rewind.command

function M.init_tags_color()
	local _, board = util.get_cursor_content("boards")
	local _, list = util.get_cursor_content("lists")
	local buf = util.buf.get("tasks")

	if list and board and buf then
		vim.api.nvim_buf_clear_namespace(buf, -1, 0, -1)
		command.list.tasks.get(list, nil, function(title, state, date, tags, id)
			local name = util.buf.get_line("tasks", id)
			if name then
				local start = name:find("󰌕")
				start = start + 1
				local ns = vim.api.nvim_create_namespace(string.format("%s_%s_%d", board.title, title, id))
				if start and ns then
					local cumulative_offset = 0
					for id_tag, tag in ipairs(tags) do
						local highlight_name =
							string.format("%s_%s_%s_%d_%d", board.title, title, tag.title, id, id_tag)
						local start_pos = start + cumulative_offset
						vim.api.nvim_set_hl(0, highlight_name, { fg = tag.color })
						vim.api.nvim_buf_add_highlight(buf, ns, highlight_name, id - 1, start_pos, start_pos + #"󰽢 ")
						cumulative_offset = cumulative_offset + #"󰽢 "
					end
				end
			end
		end)
	end
end

return M
