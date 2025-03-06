local M = {}
local rewind = require("rewind")
local state = rewind.state
local command = rewind.command
local util = rewind.util

function M.reset()
	for _, key in pairs(state.list) do
		local buf = M.get(key)
		if buf and vim.api.nvim_buf_is_valid(buf) then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
end

function M.init(key)
	local buf = vim.api.nvim_create_buf(false, true)

	local ns = vim.api.nvim_create_namespace(key)
	util.set_var(key .. "_ns", ns)

	vim.api.nvim_buf_set_name(buf, key)
	if not vim.api.nvim_buf_is_valid(buf) then
		print("Buffer " .. key .. " is not valid")
	end
end

function M.get(key)
	local buf = vim.fn.bufnr(key)
	if buf and vim.api.nvim_buf_is_valid(buf) then
		return buf
	end
end

function M.get_var(key)
	local buf = M.get(key)
	if buf then
		return vim.api.nvim_buf_get_var(buf, key)
	end
end

function M.get_line(key, line_id)
	local buf = M.get(key)
	if buf then
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		if line_id then
			if #lines > line_id - 1 then
				return lines[line_id]
			end
		else
			return lines
		end
	end
end

function M.is_empty(key)
	local buf = M.get(key)
	if buf then
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		if #lines > 0 and lines[1] ~= "" then
			return true
		end
	end
end

function M.set_var(key, var)
	local buf = M.get(key)
	if buf and var and vim.api.nvim_buf_is_valid(buf) then
		vim.api.nvim_buf_set_var(buf, key, var)
	end
end

function M.set_line(key, line_id, value)
	local buf = M.get(key)
	if buf and line_id and value then
		vim.api.nvim_buf_set_lines(buf, line_id - 1, line_id, false, { value })
		return true
	end
	return false
end

function M.set_content(key, content)
	local buf = M.get(key)
	if buf then
		vim.api.nvim_buf_set_option(buf, "modifiable", true)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
		vim.api.nvim_buf_set_option(buf, "modifiable", false)
		-- oula oula
		local autocmds = vim.api.nvim_get_autocmds({ event = "BufWrite_" .. key })
		if #autocmds > 0 then
			vim.api.nvim_exec_autocmds("BufWrite_" .. key, { pattern = key })
		end
	end
end

return M
