local M = {}
local rewind = require("rewind")
local ui = rewind.ui
local util = rewind.util
local command = rewind.command

function M.open_window(key)
	local _, task = util.get_cursor_content("tasks")
	if not task or not task.desc then
		return nil
	end

	util.win.set(key)

	local buf = util.buf.get(key)
	local win = util.win.get(key)
	if win and buf then
		vim.api.nvim_buf_set_option(buf, "modifiable", true)

		-- Split the description into lines
		local lines = vim.split(task.desc or "", "\n")
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

		local last_line = #lines
		local last_col = #lines[last_line]
		vim.api.nvim_win_set_cursor(win, { last_line, last_col })

		-- Set the buffer's filetype to markdown
		vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

		-- Change window title
		util.change_window_title(key, "- [ Markdown ] ")
		vim.cmd("startinsert!")
	end
end

function M.close_window(key, skip)
	vim.cmd("stopinsert")

	if not skip then
		-- Get all lines from the buffer
		local lines = table.concat(util.buf.get_line(key), "\n")

		vim.schedule(function()
			command.update_item("tasks", { key = "desc", data = lines })
			util.tasks.init_tags_color()
		end)
	end

	util.switch_window("tasks")
	util.win.close(key)
end

return M
