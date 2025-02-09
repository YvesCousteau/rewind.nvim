local M = {}

function M.toggle_window(win)
	if win and vim.api.nvim_win_is_valid(win) then
		if vim.api.nvim_win_is_visible(win) then
			vim.api.nvim_win_hide(win)
		else
			vim.api.nvim_win_set_config(win, { relative = "editor" })
		end
	else
		print("Window is invalid or does not exist.")
	end
end

return M
