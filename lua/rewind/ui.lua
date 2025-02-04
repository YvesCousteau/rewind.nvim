local api = vim.api

local util = require("rewind.util")
local workflow = require("rewind.workflow")
local keymap = require("rewind.keymap")
local help = require("rewind.help")

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
				for _, window_id in pairs(win) do
					if closed_win_id == window_id then
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

	local boards_win = api.nvim_open_win(buf.boards, true, {
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

	return boards_win
end

local function create_lists_window()
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor(width * 1.48)

	local lists_win = api.nvim_open_win(buf.lists, false, {
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

	return lists_win
end

local function create_tasks_window()
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor(width * 2.52)

	local tasks_win = api.nvim_open_win(buf.tasks, false, {
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

	return tasks_win
end

local function create_help_window()
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor(width * 3.56)

	local help_win = api.nvim_open_win(buf.help, false, {
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

	return help_win
end

local function init_window()
	buf = {
		boards = api.nvim_create_buf(false, true),
		lists = api.nvim_create_buf(false, true),
		tasks = api.nvim_create_buf(false, true),
		help = api.nvim_create_buf(false, true),
	}
	api.nvim_buf_set_option(buf.lists, "modifiable", false)
	api.nvim_buf_set_option(buf.tasks, "modifiable", false)

	win = {
		boards = create_boards_window(),
		lists = create_lists_window(),
		tasks = create_tasks_window(),
		help = create_help_window(),
	}

	api.nvim_buf_set_lines(buf.boards, 0, -1, false, util.get_boards())
	api.nvim_buf_set_option(buf.boards, "modifiable", false)

	help.init(buf.help)
	api.nvim_buf_set_option(buf.help, "modifiable", false)

	workflow.init_boards_selection(win, buf)

	init_close_autocmd()
end

--------------------------------------------------
-- Public Functions
--------------------------------------------------
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
		keymap.quit(buf)
	end
end

function M.close_window()
	if M.is_window_open() then
		for _, w in pairs(win) do
			if api.nvim_win_is_valid(w) then
				api.nvim_win_close(w, true)
			end
		end
		win = nil
		api.nvim_clear_autocmds({ group = rewind_augroup })
	end
end

return M
