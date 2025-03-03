local M = {}
local rewind = require("rewind")
local config = rewind.config
local util = rewind.util
local data = rewind.data
local command = rewind.command

function generate_unique_color(index)
	local r = math.random(0, 255)
	local g = math.random(0, 255)
	local b = math.random(0, 255)
	return string.format("#%02X%02X%02X", r, g, b)
end

function M.get(current_tag, callback)
	local key = "tags"
	local _, current_board = util.get_cursor_content("boards")
	local buf = util.buf.get(key)

	local boards = data.load_items()
	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and board.tags and #board.tags > 0 then
			for id, tag in ipairs(board.tags) do
				if current_tag then
					if tag.title == current_tag.title then
						return id, tag
					end
				else
					if buf then
						callback(buf, board, id, tag)
					end
				end
			end
		end
	end
end

function M.get_items()
	local items = {}
	local raw_items = {}
	local _, current_board = util.get_cursor_content("boards")

	local boards = data.load_items()
	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and board.tags and #board.tags > 0 then
			for _, tag in ipairs(board.tags) do
				table.insert(items, " 󰽢 " .. tag.title)
				table.insert(raw_items, tag)
			end
		end
	end
	return items, raw_items
end

function M.add_item(tag)
	local _, current_board = util.get_cursor_content("boards")

	local buf = util.buf.get("tags")

	local boards = data.load_items()
	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and board.tags and buf then
			for _, existing_tag in ipairs(board.tags) do
				if existing_tag.title == tag then
					print("tag " .. tag .. " is already present")
					return false
				end
			end

			local new_color = generate_unique_color(#board.tags)

			table.insert(board.tags, {
				title = tag,
				color = new_color,
			})

			local updated = command.update_item("boards", {
				key = "tags",
				data = board.tags,
			})

			if updated then
				return data.update_items(boards)
			end
		end
	end
	return false
end

function M.update_item(value)
	local _, current_board = util.get_cursor_content("boards")
	local _, current_list = util.get_cursor_content("lists")
	local _, current_task = util.get_cursor_content("tasks")

	local boards = data.load_items()
	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)
		if board and board.tags then
			board.tags[value.id][value.key] = value.data
			command.update_item("boards", {
				key = "tags",
				data = board.tags,
			})
			return data.update_items(boards)
		end
	end
end

function M.delete_item()
	local _, current_board = util.get_cursor_content("boards")
	local _, current_tag = util.get_cursor_content("tags")
	local id, tag = M.get(current_tag)

	local boards = data.load_items()
	if boards and current_board then
		local _, board = command.list.boards.get(boards, current_board)

		if board and board.lists then
			for _, list in ipairs(board.lists) do
				if list and list.tasks then
					for _, task in ipairs(list.tasks) do
						if task and task.tags then
							for task_id, task_tag in ipairs(task.tags) do
								if task_tag.title == tag.title then
									table.remove(task.tags, task_id)
								end
							end
						end
					end
				end
			end
		end

		if board and current_tag then
			if board.tags and id then
				table.remove(board.tags, id)
				return data.update_items(boards)
			end
		end
	end
end

return M
