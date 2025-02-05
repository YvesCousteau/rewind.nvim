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

local full_width = math.floor((vim.o.columns * config.width_percentage) / 4)
local full_height = math.floor((vim.o.lines * config.height_percentage) / 2)

--------------------------------------------------
-- Helper Functions
--------------------------------------------------
local function init_close_autocmd()
	api.nvim_create_autocmd("WinClosed", {
		group = rewind_augroup,
		callback = function(opts)
			local closed_win_id = tonumber(opts.match)
			if win_core then
				for _, win_id in pairs(win_core) do
					if closed_win_id == win_id then
						M.close_window(win_core)
						M.close_window(win_opt)
						return
					end
				end
			end
		end,
	})
end

local function create_window(type, win, title, width, height, col, row, is_focused, is_modifiable)
	win[type] = api.nvim_open_win(buf[type], is_focused, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		title = title,
		title_pos = "center",
		style = "minimal",
		border = "rounded",
		zindex = 100,
	})
	api.nvim_buf_set_option(buf[type], "modifiable", is_modifiable)
	rewind.keymap.quit(win, buf[type])
	rewind.keymap.help(buf[type])
end

local function create_boards_window()
	create_window(
		"boards",
		win_core,
		" 󱁳 BOARDS ",
		math.floor((vim.o.columns * config.width_percentage) / 4),
		math.floor((vim.o.lines * config.height_percentage) / 2),
		math.floor((vim.o.lines * config.width_percentage) * 0.44),
		math.floor((vim.o.lines * config.height_percentage) / 2),
		true,
		true
	)

	api.nvim_buf_set_lines(buf.boards, 0, -1, false, rewind.util.get_boards())
	api.nvim_buf_set_option(buf.boards, "modifiable", false)
end

local function create_lists_window()
	create_window(
		"lists",
		win_core,
		" 󰉺 LISTS ",
		math.floor((vim.o.columns * config.width_percentage) / 4),
		math.floor((vim.o.lines * config.height_percentage) / 2),
		math.floor((vim.o.lines * config.width_percentage) * 1.48),
		math.floor((vim.o.lines * config.height_percentage) / 2),
		false,
		false
	)
end

local function create_tasks_window()
	create_window(
		"tasks",
		win_core,
		" TASKS ",
		math.floor((vim.o.columns * config.width_percentage) / 4),
		math.floor((vim.o.lines * config.height_percentage) / 2),
		math.floor((vim.o.lines * config.width_percentage) * 2.52),
		math.floor((vim.o.lines * config.height_percentage) / 2),
		false,
		false
	)
end

local function create_help_window()
	create_window(
		"help",
		win_opt,
		" 󰋖 HELP ",
		math.floor((vim.o.columns * config.width_percentage) / 4),
		math.floor((vim.o.lines * config.height_percentage) / 2),
		math.floor((vim.o.lines * config.width_percentage) * 3.56),
		math.floor((vim.o.lines * config.height_percentage) / 2),
		false,
		true
	)

	local current_buf = api.nvim_get_current_buf()
	rewind.help.update_help(buf, current_buf)
	api.nvim_buf_set_option(buf.help, "modifiable", false)
end

local function create_input_window(callback, default_input)
	create_window(
		"input",
		win_opt,
		"   INPUT ",
		60,
		1,
		math.floor((vim.o.lines * 60) / 2),
		math.floor((vim.o.lines * 1) / 2),
		true,
		true
	)

	local line_length = #default_input
	api.nvim_win_set_cursor(win_opt.input, { 1, line_length })
	vim.cmd("startinsert!")

	rewind.keymap.enter_input(buf.input, callback)
	rewind.keymap.escape_input(buf.input)
end

local function init_window()
	buf = {
		boards = api.nvim_create_buf(false, true),
		lists = api.nvim_create_buf(false, true),
		tasks = api.nvim_create_buf(false, true),
		help = api.nvim_create_buf(false, true),
		input = api.nvim_create_buf(false, true),
	}

	create_boards_window()
	create_lists_window()
	create_tasks_window()

	rewind.workflow.init_boards_selection(win_core, buf)
	init_close_autocmd()
end

--------------------------------------------------
-- Public Functions
--------------------------------------------------
function M.is_window_open(win)
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

function M.close_window(win)
	if M.is_window_open(win) then
		for _, win_id in pairs(win) do
			if api.nvim_win_is_valid(win_id) then
				api.nvim_win_close(win_id, true)
			end
		end
		win = nil
		api.nvim_clear_autocmds({ group = rewind_augroup })
	end
end

function M.open_input_window(callback, default_input)
	create_input_window(function(input)
		vim.schedule(function()
			if input then
				callback(input)
			end
		end)
	end, default_input)
	return input_result
end

function M.close_input_window()
	if win_opt.input and win_opt.input and api.nvim_win_is_valid(win_opt.input) then
		api.nvim_win_close(win_opt.input, true)
		vim.cmd("stopinsert")
	end
end

function M.open_help_window()
	create_help_window()
end

function M.close_help_window()
	if win_opt and win_opt.help and api.nvim_win_is_valid(win_opt.help) then
		api.nvim_win_close(win_opt.help, true)
	end
end

function M.toggle_help_window()
	if win_opt.help and api.nvim_win_is_valid(win_opt.help) then
		M.close_help_window()
	else
		M.open_help_window()
	end
end

function M.toggle_ui()
	if M.is_window_open(win_core) or M.is_window_open(win_opt) then
		M.close_window(win_core)
		M.close_window(win_opt)
	else
		init_window()
	end
end

return M
