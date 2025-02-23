local M = {}
local rewind = require("rewind")
local ui = rewind.ui
local util = rewind.util

function M.open_window(key)
	util.win.set(key)
end

function M.close_window(key, skip)
	local confirmation = util.get_var(key)
	if not confirmation or not confirmation.key or not confirmation.callback then
		return nil
	end

	if not skip then
		local line_id = util.win.get_cursor_line_id(key)
		local confirmation_value = nil
		if line_id == 1 then
			confirmation_value = true
		end

		vim.schedule(function()
			if confirmation_value then
				confirmation.callback(confirmation_value)
			end
		end)
	end

	util.switch_window(confirmation.key)
	util.win.close(key)
end

return M
