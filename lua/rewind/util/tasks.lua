local M = {}
local rewind = require("rewind")
local util = rewind.util
local command = rewind.command
local data = rewind.data

function M.init_tags_color()
	local _, current_board = util.get_cursor_content("boards")
	local _, current_list = util.get_cursor_content("lists")
	local buf = util.buf.get("tasks")

	local boards = data.load_items()
	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and current_list then
			local _, list = command.list.lists.get(board, current_list)
			if buf then
				command.list.tasks.get(list, nil, function(title, state, date, tags, id)
					local name = util.buf.get_line("tasks", id)
					if name then
						local start = name:find("󰌕")
						local ns = vim.api.nvim_create_namespace(string.format("%s_%s_%d", board.title, title, id))
						if start and ns then
							start = start + 1
							local cumulative_offset = 0
							for id_tag, tag in ipairs(tags) do
								local highlight_name =
									string.format("%s_%s_%s_%d_%d", board.title, title, tag.title, id, id_tag)
								local start_pos = start + cumulative_offset
								vim.api.nvim_set_hl(0, highlight_name, { fg = tag.color })
								vim.api.nvim_buf_add_highlight(
									buf,
									ns,
									highlight_name,
									id - 1,
									start_pos,
									start_pos + #"󰽢 "
								)
								cumulative_offset = cumulative_offset + #"󰽢 "
							end
						end
					end
				end)
			end
		end
	end
end

return M
