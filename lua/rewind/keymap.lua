local api = vim.api

local M = {}

--------------------------------------------------
-- Public Functions
--------------------------------------------------
function M.init_quit_keybinding(buf)
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

return M
