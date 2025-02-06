local api = vim.api
local rewind = require("rewind")
local M = {}

M.util = rewind.lazy_load("rewind.ui.util")
M.boards = rewind.lazy_load("rewind.ui.boards")
M.lists = rewind.lazy_load("rewind.ui.lists")
M.tasks = rewind.lazy_load("rewind.ui.tasks")
M.input = rewind.lazy_load("rewind.ui.input")

--------------------------------------------------
-- Helper Functions
--------------------------------------------------
local function init_window()
	rewind.state.buf.boards = api.nvim_create_buf(false, true)
	rewind.state.buf.lists = api.nvim_create_buf(false, true)
	rewind.state.buf.tasks = api.nvim_create_buf(false, true)
	rewind.state.buf.help = api.nvim_create_buf(false, true)
	rewind.state.buf.input = api.nvim_create_buf(false, true)

	M.boards.create_window()
	M.lists.create_window()
	M.tasks.create_window()

	rewind.ui.boards.setup()
	rewind.autocmd.setup()
end

--------------------------------------------------
-- Public Functions
--------------------------------------------------
function M.is_window_open(win)
	if win and api.nvim_win_is_valid(win) then
		return true
	else
		return false
	end
end

function M.close_window(win)
	if M.is_window_open(win) then
		api.nvim_win_close(win, true)
		win = nil
	end
end

function M.close_all_window()
	for _, win in pairs(rewind.state.win.static) do
		if M.is_window_open(win) then
			M.close_window(win)
		end
	end
	for _, win in pairs(rewind.state.win.floating) do
		if M.is_window_open(win) then
			M.close_window(win)
		end
	end
end

function M.toggle_ui()
	local win_is_open = false
	for _, win in pairs(rewind.state.win.static) do
		if M.is_window_open(win) then
			M.close_window(win)
			win_is_open = true
		end
	end
	for _, win in pairs(rewind.state.win.floating) do
		if M.is_window_open(win) then
			M.close_window(win)
			win_is_open = true
		end
	end
	if not win_is_open then
		init_window()
	end
end

return M
