local api = vim.api
local rewind = require("rewind")
local M = {}
local win_augroup = api.nvim_create_augroup("WindowGroup", { clear = true })

M.util = rewind.lazy_load("rewind.ui.util")
M.boards = rewind.lazy_load("rewind.ui.boards")
M.lists = rewind.lazy_load("rewind.ui.lists")
M.tasks = rewind.lazy_load("rewind.ui.tasks")

--------------------------------------------------
-- Helper Functions
--------------------------------------------------
local function init_close_autocmd()
	api.nvim_create_autocmd("WinClosed", {
		group = win_group,
		callback = function(opts)
			local closed_win_id = tonumber(opts.match)
			if rewind.state.win.static then
				for _, win in pairs(rewind.state.win.static) do
					if closed_win_id == win then
						M.close_all_window()
						return
					end
				end
			end
		end,
	})
end

local function init_window()
	rewind.state.buf.boards = api.nvim_create_buf(false, true)
	rewind.state.buf.lists = api.nvim_create_buf(false, true)
	rewind.state.buf.tasks = api.nvim_create_buf(false, true)
	rewind.state.buf.help = api.nvim_create_buf(false, true)
	rewind.state.buf.input = api.nvim_create_buf(false, true)

	M.boards.create_window()
	M.lists.create_window()
	M.tasks.create_window()

	-- rewind.workflow.init_boards_selection(win_core, buf)
	init_close_autocmd()
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
