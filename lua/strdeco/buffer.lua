local M = {}

local api = vim.api
local fn = vim.fn

function M.get_current_row()
	return fn.getpos(".")[2]
end

function M.get_lines(bufnr, start_row, end_row)
	if bufnr == nil then
		bufnr = 0
	end
	local lines = api.nvim_buf_get_lines(bufnr, start_row - 1, end_row, true)

	return lines
end

function M.get_row_column_length(bufnr, row_num)
	local lines = M.get_lines(bufnr, row_num, row_num)
	return api.nvim_strwidth(lines[1])
end

return M
