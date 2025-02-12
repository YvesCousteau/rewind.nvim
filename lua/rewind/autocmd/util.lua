local M = {}
local rewind = require("rewind")
local util = rewind.util

function M.set_autocmd(key, events, callback)
	local buf = util.buf.get_buffer(key)
	if buf and #events > 0 then
		for _, event in pairs(events) do
			vim.api.nvim_clear_autocmds({
				event = event,
				buffer = buf,
			})
		end
		vim.api.nvim_create_autocmd(events, {
			buffer = buf,
			callback = callback,
		})
	else
		print("Unable to set a autocmd " .. event .. " for buffer " .. key)
	end
end

return M
