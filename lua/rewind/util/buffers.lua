local M = {}
local state = require("rewind.state")

function M.reset_buffers()
	for _, buf in pairs(state.buf) do
		if vim.api.nvim_buf_is_valid(buf) then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
end

function M.init_buffer(key)
	state.buf[key] = vim.api.nvim_create_buf(false, true)
	if not vim.api.nvim_buf_is_valid(state.buf[key]) then
		print("Buffer " .. key .. " is not valid")
	end
end

function M.get_buffer(key)
	local buf = state.buf[key]
	if not vim.api.nvim_buf_is_valid(buf) then
		print("Buffer " .. key .. " is not valid")
	else
		return buf
	end
end

function M.get_current_buffer()
	local current_buf = vim.api.nvim_get_current_buf()
	for key, buf in pairs(state.buf) do
		if current_buf == buf then
			print(key)
		end
	end
end

function M.get_buffer_line(key)
	local row, col = unpack(vim.api.nvim_buf_get_mark(state.buf[key], '"'))
	local lines = vim.api.nvim_buf_get_lines(state.buf[key], row - 1, row, false)
	if #lines > 0 then
		return lines[1]
	else
		return nil
	end
end

function M.set_buffer(key, content)
	vim.api.nvim_buf_set_option(state.buf[key], "modifiable", true)
	vim.api.nvim_buf_set_lines(state.buf[key], 0, -1, false, content)
	vim.api.nvim_buf_set_option(state.buf[key], "modifiable", false)
end

return M
