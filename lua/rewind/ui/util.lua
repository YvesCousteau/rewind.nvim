local M = {}
local rewind = require("rewind")
local config = rewind.config
local util = rewind.util
local ui = rewind.ui
local keymap = rewind.keymap
local command = rewind.command
local autocmd = rewind.autocmd

function M.init_window(key)
	local config_default = config.windows
	local config_specific = config.windows.custom[key] or {}

	local width_percentage = config_specific.width_percentage or config_default.width_percentage
	local height_percentage = config_specific.height_percentage or config_default.height_percentage
	local width_mult = config_specific.width_mult or config_default.width_mult
	local height_mult = config_specific.height_mult or config_default.height_mult
	local col_mult = config_specific.col_mult or config_default.col_mult
	local row_mult = config_specific.row_mult or config_default.row_mult
	local layout = config_specific.layout or config_default.layout
	local border = config_specific.border or config_default.border
	local zindex = config_specific.zindex or config_default.zindex
	local title = config_specific.title or config_default.title

	local is_visible = config_specific.is_visible or config_default.is_visible
	local is_focused = config_specific.is_focused or config_default.is_focused

	local width = math.floor(vim.o.columns * width_percentage)
	local height = math.floor(vim.o.lines * height_percentage)

	local opts = {
		relative = "editor",
		width = math.floor(width * width_mult),
		height = math.floor(height * height_mult),
		col = math.floor(width * col_mult),
		row = math.floor(height * row_mult),
		title = title,
		title_pos = layout,
		style = "minimal",
		border = border,
		zindex = zindex,
	}

	local current_win = vim.api.nvim_open_win(util.buf.get_buffer(key), is_focused == "true", opts)

	if not vim.api.nvim_win_is_valid(current_win) then
		print("Window " .. key .. " is not valid")
	end

	util.win.set_window(key, current_win)

	autocmd.setup(key)
	keymap.setup(key)
	command.get_items(key)

	if is_visible == "false" then
		util.win.close_window(key, current_win)
	end
end

function M.help_toggle_window(key)
	local is_visible = util.toggle_visiblity(key)
	if is_visible == "false" then
		util.win.close_window(key)
	else
		M.init_window(key)
	end
end

function M.prompt_toggle_window(key)
	local is_visible = util.toggle_visiblity(key)
	if is_visible == "false" then
		vim.cmd("stopinsert")
		local prev_buf = util.get_prev_buf()
		util.switch_window(prev_buf)
		util.win.close_window(key)
	else
		M.init_window(key)
		local prev_buf = util.get_prev_buf()
		local default_prompt = util.buf.get_buffer_line(prev_buf) or ""

		local key = "prompt"
		local buf = util.buf.get_buffer(key)
		local win = util.win.get_window(key)
		if win and buf then
			vim.api.nvim_buf_set_option(buf, "modifiable", true)
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, { default_prompt or "" })
			local line_length = #default_prompt
			vim.api.nvim_win_set_cursor(win, { 1, line_length })
			vim.cmd("startinsert!")
		end
	end
end

return M
