local api = vim.api
local rewind = require("rewind")
local M = {}

local function lazy_load(module_name)
	return setmetatable({}, {
		__index = function(_, key)
			return require(module_name)[key]
		end,
	})
end

M.util = lazy_load("rewind.ui.util")
M.boards = lazy_load("rewind.ui.boards")
M.lists = lazy_load("rewind.ui.lists")
M.tasks = lazy_load("rewind.ui.tasks")

local config = {
	width_percentage = 0.8,
	height_percentage = 0.8,
}

--------------------------------------------------
-- Local Variables and Cache
--------------------------------------------------
---@type table|nil
local win_core = {
	boards = nil,
	lists = nil,
	tasks = nil,
}
---@type table|nil
local win_opt = {
	help = nil,
	input = nil,
}
---@type table|nil
local buf = nil

local rewind_augroup = api.nvim_create_augroup("RewindGroup", { clear = true })

--------------------------------------------------
-- Helper Functions
--------------------------------------------------
local function init_close_autocmd()
	api.nvim_create_autocmd("WinClosed", {
		group = rewind_augroup,
		callback = function(opts)
			local closed_win_id = tonumber(opts.match)
			if win_core then
				for _, win in pairs(win_core) do
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
	buf = {
		boards = api.nvim_create_buf(false, true),
		lists = api.nvim_create_buf(false, true),
		tasks = api.nvim_create_buf(false, true),
		help = api.nvim_create_buf(false, true),
		input = api.nvim_create_buf(false, true),
	}

	M.boards.create_window(buf, win_core, config)
	M.lists.create_window(buf, win_core, config)
	M.tasks.create_window(buf, win_core, config)

	rewind.workflow.init_boards_selection(win_core, buf)
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

function M.close_all_window(win)
	for _, win in pairs(win_core) do
		if M.is_window_open(win) then
			M.close_window(win)
		end
	end
	for _, win in pairs(win_opt) do
		if M.is_window_open(win) then
			M.close_window(win)
		end
	end
end

function M.toggle_ui()
	local win_is_open = false
	for _, win in pairs(win_core) do
		if M.is_window_open(win) then
			M.close_window(win)
			win_is_open = true
		end
	end
	for _, win in pairs(win_opt) do
		if M.is_window_open(win) then
			M.close_window(win)
			win_is_open = true
		end
	end
	if not win_is_open then
		init_window()
	end
end

function M.get_buf

return M
