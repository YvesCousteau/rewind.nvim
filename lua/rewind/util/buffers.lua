local M = {}
local rewind = require("rewind")
local state = rewind.state

function M.reset_buffers()
	for _, buf in pairs(state.buf) do
		if vim.api.nvim_buf_is_valid(buf) then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
end

function M.init_buffer(key)
	local buf = vim.api.nvim_create_buf(false, true)
	if not vim.api.nvim_buf_is_valid(buf) then
		print("Buffer " .. key .. " is not valid")
	end
	M.set_buffer(key, buf)
end

function M.get_buffer(key)
	local buf = state.buf[key]
	if buf and not vim.api.nvim_buf_is_valid(buf) then
		print("Unable to get buffer " .. key)
	else
		return buf
	end
end

function M.set_buffer(key, buf)
	if buf and vim.api.nvim_buf_is_valid(buf) then
		state.buf[key] = buf
	end
end

function M.get_buffer_line(key)
	local buf = M.get_buffer(key)
	local row, col = unpack(vim.api.nvim_buf_get_mark(buf, '"'))
	local lines = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)
	if #lines > 0 then
		return lines[1]
	else
		return nil
	end
end

function M.is_buffer_empty(key)
	local buf = M.get_buffer(key)
	if buf then
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		if #lines > 0 then
			return true
		end
	end
end

function M.set_buffer_content(key, content)
	local buf = M.get_buffer(key)
	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

return M
