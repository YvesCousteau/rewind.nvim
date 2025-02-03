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
local win_results_id = nil
---@type integer|nil
local buf_results_id = nil

---@type integer|nil
local win_prompt_id = nil
---@type integer|nil
local buf_prompt_id = nil
---@type table
local results_list = {}

--------------------------------------------------
-- Helper Functions
--------------------------------------------------
local function create_prompt(width, height)
	buf_prompt_id = api.nvim_create_buf(false, true)

	local opts = {
		relative = "editor",
		width = width,
		height = 3,
		col = math.floor(width * 0.1),
		row = math.floor(height * 0.9),
		anchor = "NW",
		style = "minimal",
		border = "rounded",
	}

	win_prompt_id = api.nvim_open_win(buf_prompt_id, true, opts)

	-- Set buffer options
	api.nvim_buf_set_option(buf_prompt_id, "modifiable", true)
	api.nvim_buf_set_option(buf_prompt_id, "buftype", "prompt")
	vim.fn.prompt_setprompt(buf_prompt_id, "Enter text: ")

	-- Keymap for Enter key to process input
	api.nvim_buf_set_keymap(
		buf_prompt_id,
		"i",
		"<CR>",
		"<Cmd>lua require('rewind.ui').process_input()<CR>",
		{ noremap = true, silent = true }
	)
end

local function create_results(width, height)
	buf_results_id = api.nvim_create_buf(false, true)

	local opts = {
		relative = "editor",
		width = width,
		height = math.floor(height * 0.8),
		col = math.floor(width * 0.1),
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
	local buffers = { buf_results_id, buf_prompt_id }
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

	create_results(width, height)
	create_prompt(width, height)

	set_keymaps()

	-- Set up autocmd to update results window
	api.nvim_set_current_win(win_prompt_id)
end

local function is_window_open()
	return (win_results_id ~= nil and api.nvim_win_is_valid(win_results_id))
		or (win_prompt_id ~= nil and api.nvim_win_is_valid(win_prompt_id))
end

--------------------------------------------------
-- Public Functions
--------------------------------------------------
function M.process_input()
	if buf_prompt_id and api.nvim_buf_is_valid(buf_prompt_id) then
		local prompt_content = api.nvim_buf_get_lines(buf_prompt_id, 0, -1, false)[1] or ""
		if prompt_content ~= "" then
			table.insert(results_list, prompt_content)
			M.update_results()
			api.nvim_buf_set_lines(buf_prompt_id, 0, -1, false, { "" }) -- Clear prompt
		end
	end
end

function M.update_results()
	if buf_results_id and api.nvim_buf_is_valid(buf_results_id) then
		api.nvim_buf_set_option(buf_results_id, "modifiable", true)
		api.nvim_buf_set_lines(buf_results_id, 0, -1, false, results_list)
		api.nvim_buf_set_option(buf_results_id, "modifiable", false)
	end
end

function M.toggle_ui()
	if is_window_open() then
		M.close_window()
	else
		create_window()
	end
end

function M.close_window()
	if is_window_open() then
		api.nvim_win_close(win_results_id, true)
		api.nvim_win_close(win_prompt_id, true)
		win_results_id = nil
		buf_results_id = nil
		win_prompt_id = nil
		buf_prompt_id = nil
		results_list = {} -- Clear history on close
	end
end

return M
