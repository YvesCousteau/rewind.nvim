local M = {}
local rewind = require("rewind")
local config = rewind.config
local state = rewind.state
local util = rewind.util
local ui = rewind.ui

function M.reset_windows()
	for _, win in pairs(state.win) do
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end
	state.win = {}
end

function M.get_window(key)
	local win = state.win[key]
	if win and not vim.api.nvim_win_is_valid(win) then
		print("Unable to get window " .. key)
	else
		return win
	end
end

function M.set_window(key, win)
	if win and vim.api.nvim_win_is_valid(win) then
		state.win[key] = win
	end
end

function M.toggle_window(key)
	if config.windows.custom[key].is_visible == "false" then
		config.windows.custom[key].is_visible = "true"
	else
		config.windows.custom[key].is_visible = "false"
	end
	local is_visible = config.windows.custom[key].is_visible
	print(key .. " |> " .. is_visible)
	if is_visible == "false" then
		M.close_window(key)
	else
		ui.util.init_window(key)
	end
end

function M.close_window(key, x)
	local win = state.win[key]
	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_close(win, true)
	else
		print("Window with key '" .. key .. "' is not valid or does not exist.")
	end
	state.win[key] = nil
end

return M
