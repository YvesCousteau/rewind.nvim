local M = {}
local config = require("rewind.config")
local util = require("rewind.util")

function M.get_items()
	if vim.api.nvim_win_is_valid(util.win.get_window("help_min")) then
		return config.help.min.init
	elseif vim.api.nvim_win_is_valid(util.win.get_window("help_max")) then
		local items = vim.deepcopy(config.help.max.init)
		local current_buf_key = util.buf.get_current_buffer_key()
		for _, line in ipairs(config.win.help_max[current_buf_key]) do
			table.insert(items, line)
		end
		return items
	end
end

return M
