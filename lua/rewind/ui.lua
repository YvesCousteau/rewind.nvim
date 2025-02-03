local api = vim.api

local utils = require("rewind.utils")

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
---@type integer|nil
local win = nil
---@type integer|nil
local buf = nil

--------------------------------------------------
-- Helper Functions
--------------------------------------------------

local function setup_selection(buf, callback)
	vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "", {
		callback = function()
			local line = vim.api.nvim_get_current_line()
			vim.api.nvim_win_close(0, true)
			callback(line)
		end,
		noremap = true,
		silent = true,
	})
end

local function create_window(contents)
	local width = math.floor(vim.o.columns * config.width_percentage)
	local height = math.floor(vim.o.lines * config.height_percentage)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	buf = vim.api.nvim_create_buf(false, true)
	win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = (vim.o.columns - width) / 2,
		row = (vim.o.lines - height) / 2,
		style = "minimal",
		border = "rounded",
	})

	api.nvim_buf_set_lines(buf, 0, -1, false, contents)

	setup_selection(buf, function(selection)
		print("Selected: " .. selection)
	end)
end

--------------------------------------------------
-- Public Functions
--------------------------------------------------
function M.is_window_open()
	return win ~= nil and api.nvim_win_is_valid(win)
end

function M.toggle_ui()
	if M.is_window_open() then
		M.close_window()
	else
		local data = utils.load_json_file("/home/me/perso/rewind.nvim/test/data.json")
		if not data or type(data) ~= "table" then
			print("Failed to load JSON file or invalid data")
			return
		end

		local names = {}
		for _, item in ipairs(data) do
			if item.title then
				table.insert(names, item.title)
			end
		end
		create_window(names)
	end
end

function M.close_window()
	if M.is_window_open() then
		api.nvim_win_close(win, true)
	end
end

return M
