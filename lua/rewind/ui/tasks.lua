local api = vim.api
local rewind = require("rewind")
local M = {}

function M.setup()
	api.nvim_buf_set_option(rewind.state.buf.tasks, "modifiable", true)

	rewind.autocmd.cursor_move(rewind.state.buf.tasks, function()
		rewind.util.update_highlight(rewind.state.buf.tasks, rewind.state.highlight_namespace)
		rewind.state.set_current("task", api.nvim_get_current_line())
	end)

	api.nvim_buf_set_option(rewind.state.buf.tasks, "modifiable", false)

	rewind.util.clear_highlights(rewind.state.buf, rewind.state.highlight_namespace)
	rewind.util.update_highlight(rewind.state.buf.tasks, rewind.state.highlight_namespace)

	rewind.util.set_keymap(rewind.state.buf.tasks, "n", rewind.config.options.keymaps.select, function()
		local current_task = api.nvim_get_current_line()
		rewind.ui.input.open_window(" |> Update Task", function(input)
			if input then
				print(input)
				-- rewind.util.update_data(input, "task", current_board, current_list, current_task)
				-- update_list_selection(buf, current_board, current_list)
			end
		end, current_task)
	end)

	rewind.util.set_keymap(rewind.state.buf.tasks, "n", rewind.config.options.keymaps.back, function()
		api.nvim_set_current_win(rewind.state.win.static.lists)
	end)
end

function M.create_window(buf, win, config)
	local pos = rewind.config.options.ui.position.tasks
	rewind.ui.util.create_window(rewind.state.buf, "tasks", rewind.state.win.static, pos, false, false)
end

return M
