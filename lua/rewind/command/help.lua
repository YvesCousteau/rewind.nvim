local M = {}
local rewind = require("rewind")
local config = rewind.config
local util = rewind.util

function M.get_items()
	local help_min_win = util.win.get_window("help_min")
	local help_max_win = util.win.get_window("help_max")
	if help_min_win and vim.api.nvim_win_is_valid(help_min_win) then
		return config.help.min.init
	elseif help_max_win and vim.api.nvim_win_is_valid(help_max_win) then
		local items = vim.deepcopy(config.help.max.init)
		-- local current_buf_key = util.buf.get_current_buffer_key()
		-- for _, line in ipairs(config.win.help_max[current_buf_key]) do
		-- table.insert(items, line)
		-- end
		return items
	end
end

return M
