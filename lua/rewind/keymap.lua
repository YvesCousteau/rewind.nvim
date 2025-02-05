local api = vim.api

local M = {}

--------------------------------------------------
-- Public Functions
--------------------------------------------------
function M.quit(buf)
	for _, buffer_id in pairs(buf) do
		if buffer_id and api.nvim_buf_is_valid(buffer_id) then
			api.nvim_buf_set_keymap(
				buffer_id,
				"n",
				"q",
				":lua require('rewind.ui').close_window()<CR>",
				{ noremap = true, silent = true }
			)
		end
	end
end

function M.select_board(buf, callback)
	api.nvim_buf_set_keymap(buf.boards, "n", "<CR>", "", {
		callback = callback,
		noremap = true,
		silent = true,
	})
end

function M.select_list(buf, callback)
	api.nvim_buf_set_keymap(buf.lists, "n", "<CR>", "", {
		callback = callback,
		noremap = true,
		silent = true,
	})
end

function M.select_task(buf, callback)
	api.nvim_buf_set_keymap(buf.tasks, "n", "<CR>", "", {
		callback = callback,
		noremap = true,
		silent = true,
	})
end

function M.escape_board(buf)
	api.nvim_buf_set_keymap(buf.boards, "n", "<Esc>", ":lua require('rewind.ui').close_window()<CR>", {
		noremap = true,
		silent = true,
	})
end

function M.escape_list(buf, callback)
	api.nvim_buf_set_keymap(buf.lists, "n", "<Esc>", "", {
		callback = callback,
		noremap = true,
		silent = true,
	})
end

function M.escape_task(buf, callback)
	api.nvim_buf_set_keymap(buf.tasks, "n", "<Esc>", "", {
		callback = callback,
		noremap = true,
		silent = true,
	})
end

return M
