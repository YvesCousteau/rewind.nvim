local M = {}
local util = require("rewind").util

function M.set_keymap(key, mode, keymaps, callback, opts)
	local buf = util.buf.get_buffer(key)
	if buf and #keymaps > 0 then
		opts = vim.tbl_extend("force", {
			noremap = true,
			silent = true,
			callback = callback,
		}, opts or {})
		for _, keymap in pairs(keymaps) do
			vim.api.nvim_buf_set_keymap(buf, mode, keymap, "", opts)
		end
	else
		print("Unable to set a keymaps " .. keymaps .. " on mode " .. mode .. " for buffer " .. key)
	end
end

return M
