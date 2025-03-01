local M = {}
local rewind = require("rewind")
local config = rewind.config
local util = rewind.util
local data = rewind.data
local command = rewind.command

function M.get_tags(callback)
	local key = "tags"
	local _, board = util.get_cursor_content("boards")
	local buf = util.buf.get(key)

	if buf and board and board.tags and #board.tags > 0 then
		for id, tag in pairs(board.tags) do
			if tag.title and tag.color then
				callback(buf, board, id, tag)
			end
		end
	end
end

function M.get_items()
	local items = {}
	local raw_items = {}
	local _, current_board = util.get_cursor_content("boards")
	if current_board and current_board.tags and #current_board.tags > 0 then
		for _, tag in pairs(current_board.tags) do
			table.insert(items, " 󰽢 " .. tag.title)
			table.insert(raw_items, tag)
		end
	end
	return items, raw_items
end

function M.add_item(tag)
	local _, current_board = util.get_cursor_content("boards")
	if current_board and current_board.tags then
		table.insert(current_board.tags, {
			title = tag,
			color = "#FFFFFF",
		})
		command.update_item("boards", {
			key = "tags",
			data = current_board.tags,
		})
		command.get_items("tags")
	end
end

return M
