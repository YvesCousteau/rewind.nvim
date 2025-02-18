local M = {}
local rewind = require("rewind")
local config = rewind.config
local state = rewind.state
local util = rewind.util
local ui = rewind.ui
local command = rewind.command

function M.reset()
	for _, key in pairs(state.list) do
		local win = M.get(key)
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end
end

function M.init(key)
	local opts, is_focused, is_visible = ui.util.get_opts(key)

	local win = vim.api.nvim_open_win(util.buf.get(key), is_focused == "true", opts)
	vim.api.nvim_win_set_name(win, key)

	if not vim.api.nvim_win_is_valid(win) then
		print("Window " .. key .. " is not valid")
	end

	command.get_items(key)

	if is_visible == "false" then
		M.close(key, win)
	end
end

function M.get(key)
	local win = vim.fn.win_findbuf(util.buf.get(key))
	if win and vim.api.nvim_win_is_valid(win) then
		return win
	end
end

function M.close(key)
	local win = M.get(key)
	if win then
		vim.api.nvim_win_close(win, true)
	else
		print("Window with key '" .. key .. "' is not valid or does not exist.")
	end
end

return M
