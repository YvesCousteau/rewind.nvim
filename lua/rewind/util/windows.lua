local M = {}
local rewind = require("rewind")
local config = rewind.config
local state = rewind.state
local util = rewind.util
local ui = rewind.ui

function M.reset()
	for _, win in pairs(state.win) do
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end
	state.win = {}
end

function M.get(key)
	local win = state.win[key]
	if win and vim.api.nvim_win_is_valid(win) then
		return win
	end
end

function M.set(key, win)
	if win and vim.api.nvim_win_is_valid(win) then
		state.win[key] = win
	end
end

function M.close(key)
	local win = M.get(key)
	if win then
		vim.api.nvim_win_close(win, true)
	else
		print("Window with key '" .. key .. "' is not valid or does not exist.")
	end
	state.win[key] = nil
end

return M
