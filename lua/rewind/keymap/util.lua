local M = {}
local util = require("rewind").util

function M.set_keymap(key, mode, keymap, callback, opts)
	local buf = util.buf.get_buffer(key)
	if buf and vim.api.nvim_buf_is_valid(buf) then
		opts = vim.tbl_extend("force", {
			noremap = true,
			silent = true,
			callback = callback,
		}, opts or {})
		vim.api.nvim_buf_set_keymap(buf, mode, keymap, "", opts)
	else
		print("Unable to set a keymap " .. keymap .. " on mode " .. mode .. " for buffer " .. key)
	end
end

return M
