local M = {}
local rewind = require("rewind")
local ui = rewind.ui
local util = rewind.util
local command = rewind.command

function M.open_window(key)
	local buf_name = vim.api.nvim_buf_get_name(0)
	local name = vim.fn.fnamemodify(buf_name, ":t")
	util.set_var("tags_buf", name)
	util.win.set(key)
end

function M.close_window(key, skip)
	local prev_buf = util.get_var("tags_buf")
	if not skip and prev_buf == "tasks" then
		local _, tag = util.get_cursor_content(key)
		local _, task = util.get_cursor_content("tasks")
		if tag and task and task.tags then
			for _, task_tag in ipairs(task.tags) do
				if tag.title == task_tag.title then
					util.switch_window(prev_buf)
					util.win.close(key)
					print("tag " .. tag.title .. " is already present in task " .. task.title)
					return
				end
			end
			table.insert(task.tags, tag)
			command.update_item("tasks", { key = "tags", data = task.tags })
			util.tasks.init_tags_color()
		end
	end

	util.switch_window(prev_buf)
	util.win.close(key)
end

return M
