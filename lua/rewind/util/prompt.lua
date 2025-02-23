local M = {}
local rewind = require("rewind")
local state = rewind.state
local util = rewind.util
local ui = rewind.ui

function M.set(key, callback, is_empty)
	local win = util.win.get("prompt")
	if win then
		ui.prompt.close_window("prompt")
	end
	local prompt = ""
	if not is_empty then
		prompt = util.get_cursor_content(key).title
		if not prompt then
			prompt = ""
		end
	end
	if key and callback and prompt then
		util.set_var("prompt", {
			key = key,
			callback = callback,
			prompt = prompt,
		})
		ui.util.toggle_window("prompt")
	end
end

return M
