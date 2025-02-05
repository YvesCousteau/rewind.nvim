local api = vim.api

local rewind = require("rewind")

-- UI Module for Rewind Plugin
---@class RewindUI
---@field toggle_floating_window function
---@field close_window function
local M = {}

-- Configuration
local config = {
	width_percentage = 0.8,
	height_percentage = 0.8,
}

--------------------------------------------------
-- Local Variables and Cache
--------------------------------------------------
---@type table|nil
local win = nil
---@type table|nil
local win_input = nil
---@type table|nil
local buf = nil

local rewind_augroup = api.nvim_create_augroup("RewindGroup", { clear = true })

local width = math.floor((vim.o.columns * config.width_percentage) / 4)
local height = math.floor((vim.o.lines * config.height_percentage) / 2)

--------------------------------------------------
-- Helper Functions
--------------------------------------------------
local function init_close_autocmd()
	api.nvim_create_autocmd("WinClosed", {
		group = rewind_augroup,
		callback = function(opts)
			local closed_win_id = tonumber(opts.match)
			if win then
				for _, win_id in pairs(win) do
					if closed_win_id == win_id then
						M.close_window()
						return
					end
				end
			end
		end,
	})
end

local function create_boards_window()
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor(width * 0.44)

	local win = api.nvim_open_win(buf.boards, true, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		title = " 󱁳 BOARDS ",
		title_pos = "center",
		style = "minimal",
		border = "rounded",
		zindex = 100,
	})
	api.nvim_buf_set_lines(buf.boards, 0, -1, false, rewind.util.get_boards())
	api.nvim_buf_set_option(buf.boards, "modifiable", false)
	return win
end

local function create_lists_window()
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor(width * 1.48)

	local win = api.nvim_open_win(buf.lists, false, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		title = " 󰉺 LISTS ",
		title_pos = "center",
		style = "minimal",
		border = "rounded",
		zindex = 100,
	})
	api.nvim_buf_set_option(buf.lists, "modifiable", false)
	return win
end

local function create_tasks_window()
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor(width * 2.52)

	local win = api.nvim_open_win(buf.tasks, false, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		title = "  TASKS ",
		title_pos = "center",
		style = "minimal",
		border = "rounded",
		zindex = 100,
	})
	api.nvim_buf_set_option(buf.tasks, "modifiable", false)
	return win
end

local function create_help_window()
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor(width * 3.56)

	local win = api.nvim_open_win(buf.help, false, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		title = " 󰋖 HELP ",
		title_pos = "center",
		style = "minimal",
		border = "rounded",
		zindex = 100,
	})
	rewind.help.init(buf.help)
	api.nvim_buf_set_option(buf.help, "modifiable", false)
	return win
end

local function create_input_window(callback)
	local row = math.floor((vim.o.lines - height) / 1)
	local col = math.floor((vim.o.columns - width) / 1)

	api.nvim_buf_set_lines(buf.input, 0, -1, false, {})

	win_input = api.nvim_open_win(buf.input, true, {
		relative = "editor",
		width = 60,
		height = 1,
		col = col,
		row = row,
		title = "   INPUT ",
		title_pos = "left",
		style = "minimal",
		border = "rounded",
		zindex = 200,
	})

	rewind.help.update(buf.help, "input")

	local line_count = api.nvim_buf_line_count(buf.input)
	local target_line = math.min(2, line_count)
	local line_length = #api.nvim_buf_get_lines(buf.input, target_line - 1, target_line, false)[1]
	local target_column = math.min(0, line_length)

	api.nvim_win_set_cursor(win_input, { target_line, target_column })
	vim.cmd("startinsert")

	vim.keymap.set("i", "<CR>", function()
		local input = api.nvim_buf_get_lines(buf.input, 0, -1, false)[1]
		vim.cmd("stopinsert")
		api.nvim_win_close(win_input, true)
		callback(input)
	end, { buffer = buf.input })

	vim.keymap.set("i", "<Esc>", function()
		vim.cmd("stopinsert")
		api.nvim_win_close(win_input, true)
	end)
end

local function init_window()
	buf = {
		boards = api.nvim_create_buf(false, true),
		lists = api.nvim_create_buf(false, true),
		tasks = api.nvim_create_buf(false, true),
		help = api.nvim_create_buf(false, true),
		input = api.nvim_create_buf(false, true),
	}

	win = {
		boards = create_boards_window(),
		lists = create_lists_window(),
		tasks = create_tasks_window(),
		help = create_help_window(),
	}

	rewind.workflow.init_boards_selection(win, buf)
	init_close_autocmd()
end

--------------------------------------------------
-- Public Functions
--------------------------------------------------
function M.open_input(callback)
	create_input_window(function(input)
		vim.schedule(function()
			if input then
				callback(input)
			end
		end)
	end)
	return input_result
end

function M.is_window_open()
	if win == nil then
		return false
	end
	for _, window_id in pairs(win) do
		if api.nvim_win_is_valid(window_id) then
			return true
		end
	end
	return false
end

function M.toggle_ui()
	if M.is_window_open() then
		M.close_window()
	else
		init_window()
		rewind.keymap.quit(buf)
	end
end

function M.close_window()
	if M.is_window_open() then
		for _, win_id in pairs(win) do
			if api.nvim_win_is_valid(win_id) then
				api.nvim_win_close(win_id, true)
			end
		end
		win = nil
		if win_input and api.nvim_win_is_valid(win_input) then
			api.nvim_win_close(win_input, true)
		end
		win_input = nil
		api.nvim_clear_autocmds({ group = rewind_augroup })
	end
end

return M
