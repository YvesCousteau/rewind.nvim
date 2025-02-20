local M = {}
local rewind = require("rewind")
local state = rewind.state
local util = rewind.util
local ui = rewind.ui

function M.set(key, callback)
	local win = util.win.get("prompt")
	if win then
		ui.prompt.close_window("prompt")
	end
	if key and callback then
		util.set_var("prompt", {
			key = key,
			callback = callback,
		})
		ui.util.toggle_window("prompt")
	end
end

return M
