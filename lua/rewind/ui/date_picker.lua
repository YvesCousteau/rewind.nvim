local M = {}
local rewind = require("rewind")
local ui = rewind.ui
local util = rewind.util
local command = rewind.command

function M.open_window(key)
	local _, task = util.get_cursor_content("tasks")
	if not task or not task.date then
		return nil
	end

	local var = nil
	if task.date == "UNDEFINED" then
		local current_date = os.date("*t", os.time())
		var = {
			current_date.year,
			current_date.month,
			current_date.day,
		}
	else
		local date_unformated = util.date_picker.get_unformated(task.date)
		if date_unformated then
			var = date_unformated
		end
	end
	if var then
		command.update_item(key, var)
	end
	util.win.set(key)
end

function M.close_window(key, skip)
	if not skip then
		local date = util.buf.get_var(key)
		if date then
			local date_formated = util.date_picker.get_formated(date)
			if date_formated then
				command.update_item("tasks", { key = "date", data = date_formated })
				util.tasks.init_tags_color()
			end
		end
	end

	util.switch_window("tasks")
	util.win.close(key)
end

return M
