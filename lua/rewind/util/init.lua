local M = {}
local rewind = require("rewind")
local state = rewind.state
local config = rewind.config
M.buf = rewind.lazy_load("rewind.util.buffers")
M.win = rewind.lazy_load("rewind.util.windows")
M.prompt = rewind.lazy_load("rewind.util.prompt")

-- function M.toggle_visiblity(key)
-- 	if config.windows.custom[key].is_visible == "false" then
-- 		config.windows.custom[key].is_visible = "true"
-- 	else
-- 		config.windows.custom[key].is_visible = "false"
-- 	end
-- 	return config.windows.custom[key].is_visible
-- end

function M.change_window_title(key, title)
	if title then
		config.windows.custom[key].title_opt = title
	end
end

function M.switch_window(key)
	local win = M.win.get(key)
	if win then
		vim.api.nvim_set_current_win(win)
	end
end

function M.get_var(name)
	local var = vim.api.nvim_get_var(name)
	if var then
		return var
	end
end

function M.set_var(name, key)
	vim.api.nvim_set_var(name, key)
end

function M.get_cursor_content(key)
	local win = M.win.get(key)
	if win then
		local line_id = vim.api.nvim_win_get_cursor(win)[1]
		local var = M.buf.get_var(key)
		if var and line_id and var[line_id] then
			return var[line_id]
		end
	end
end

function M.update_highlight(key)
	local buf = M.buf.get(key)
	local current_line_id = vim.api.nvim_win_get_cursor(0)[1] - 1
	if buf and current_line_id then
		vim.api.nvim_buf_clear_namespace(buf, -1, 0, -1)
		vim.api.nvim_buf_add_highlight(buf, -1, "classic", current_line_id, 0, -1)
	end
end

-- local random = math.random
-- function M.uuid()
-- 	local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
-- 	return string.gsub(template, "[xy]", function(c)
-- 		local v = (c == "x") and random(0, 0xf) or random(8, 0xb)
-- 		return string.format("%x", v)
-- 	end)
-- end

return M
