local api = vim.api

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
local win_view_id = nil
---@type integer|nil
local buf_view_id = nil

---@type integer|nil
local win_results_id = nil
---@type integer|nil
local buf_results_id = nil

---@type integer|nil
local win_prompt_id = nil
---@type integer|nil
local buf_prompt_id = nil

--------------------------------------------------
-- Helper Functions
--------------------------------------------------
local function create_view(width, height)
	buf_view_id = api.nvim_create_buf(false, true)

	local opts = {
		relative = "editor",
		width = math.floor(width * 0.5),
		height = math.floor(height * 0.8),
		col = math.floor(width * 0.1),
		row = math.floor(height * 0.1),
		anchor = "NW",
		style = "minimal",
		border = "rounded",
	}

	win_view_id = api.nvim_open_win(buf_view_id, true, opts)

	-- Set buffer options
	api.nvim_buf_set_option(buf_view_id, "modifiable", false)
	api.nvim_buf_set_option(buf_view_id, "buftype", "nofile")
end

local function create_prompt(width, height)
	buf_prompt_id = api.nvim_create_buf(false, true)

	local opts = {
		relative = "editor",
		width = width,
		height = math.floor(height * 0.2),
		col = math.floor(width * 0.1),
		row = math.floor(height * 0.9),
		anchor = "NW",
		style = "minimal",
		border = "rounded",
	}

	win_prompt_id = api.nvim_open_win(buf_prompt_id, true, opts)

	-- Set buffer options
	api.nvim_buf_set_option(buf_prompt_id, "modifiable", false)
	api.nvim_buf_set_option(buf_prompt_id, "buftype", "nofile")
end

local function create_results(width, height)
	buf_results_id = api.nvim_create_buf(false, true)

	local opts = {
		relative = "editor",
		width = math.floor(width * 0.5),
		height = math.floor(height * 0.8),
		col = math.floor(width * 0.6),
		row = math.floor(height * 0.1),
		anchor = "NW",
		style = "minimal",
		border = "rounded",
	}

	win_results_id = api.nvim_open_win(buf_results_id, true, opts)

	-- Set buffer options
	api.nvim_buf_set_option(buf_results_id, "modifiable", false)
	api.nvim_buf_set_option(buf_results_id, "buftype", "nofile")
end

local function set_keymaps()
	local buffers = { buf_view_id, buf_results_id, buf_prompt_id }
	for _, buf in ipairs(buffers) do
		if buf and api.nvim_buf_is_valid(buf) then
			api.nvim_buf_set_keymap(
				buf,
				"n",
				"q",
				":lua require('rewind.ui').close_window()<CR>",
				{ noremap = true, silent = true }
			)
		end
	end
end

local function create_window()
	local ui = api.nvim_list_uis()[1]
	local width = math.floor(ui.width * config.width_percentage)
	local height = math.floor(ui.height * config.height_percentage)

	create_view(width, height)
	create_results(width, height)
	create_prompt(width, height)

	set_keymaps()
end

local function update_content(contents)
	if buf_view_id and api.nvim_buf_is_valid(buf_view_id) then
		api.nvim_buf_set_option(buf_view_id, "modifiable", true)
		api.nvim_buf_set_lines(buf_view_id, 0, -1, false, contents[1])
		api.nvim_buf_set_option(buf_view_id, "modifiable", false)
	end
	if buf_results_id and api.nvim_buf_is_valid(buf_results_id) then
		api.nvim_buf_set_option(buf_results_id, "modifiable", true)
		api.nvim_buf_set_lines(buf_results_id, 0, -1, false, contents[2])
		api.nvim_buf_set_option(buf_results_id, "modifiable", false)
	end
	if buf_prompt_id and api.nvim_buf_is_valid(buf_prompt_id) then
		api.nvim_buf_set_option(buf_prompt_id, "modifiable", true)
		api.nvim_buf_set_lines(buf_prompt_id, 0, -1, false, contents[3])
		api.nvim_buf_set_option(buf_prompt_id, "modifiable", false)
	end
end

local function is_window_open()
	return (win_view_id ~= nil and api.nvim_win_is_valid(win_view_id))
		or (win_results_id ~= nil and api.nvim_win_is_valid(win_results_id))
		or (win_prompt_id ~= nil and api.nvim_win_is_valid(win_prompt_id))
end

--------------------------------------------------
-- Public Functions
--------------------------------------------------
function M.update_content(lines)
	if buf_id and api.nvim_buf_is_valid(buf_id) then
		api.nvim_buf_set_option(buf_id, "modifiable", true)
		api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
		api.nvim_buf_set_option(buf_id, "modifiable", false)
	end
end

function M.is_window_open()
	return win_id ~= nil and api.nvim_win_is_valid(win_id)
end
function M.toggle_floating_window()
	if is_window_open() then
		M.close_window()
	else
		create_window()
		update_content({
			{ "Area 1 content" },
			{ "Area 2 content" },
			{ "Area 3 content" },
		})
	end
end

function M.close_window()
	if is_window_open() then
		api.nvim_win_close(win_view_id, true)
		api.nvim_win_close(win_results_id, true)
		api.nvim_win_close(win_prompt_id, true)
		win_view_id = nil
		buf_view_id = nil
		win_results_id = nil
		buf_results_id = nil
		win_prompt_id = nil
		buf_prompt_id = nil
	end
end

return M
