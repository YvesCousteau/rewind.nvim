local M = {}

function M.set_keymap(buf, mode, key, callback, opts)
	opts = vim.tbl_extend("force", {
		noremap = true,
		silent = true,
		callback = callback,
	}, opts or {})
	vim.api.nvim_buf_set_keymap(buf, mode, key, "", opts)
end

return M
