local M = {}
local rewind = require("rewind")
local state = rewind.state
local util = rewind.util
local ui = rewind.ui

function M.set(key, callback)
	local win = util.win.get("confirmation")
	if win then
		ui.list.confirmation.close_window("confirmation")
	end

	if key and callback then
		util.set_var("confirmation", {
			key = key,
			callback = callback,
		})
		ui.util.toggle_window("confirmation")
	end
end

return M
