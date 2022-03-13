local buffer = require("strdeco.buffer")
local convert = require("strdeco.convert")

local cmd = vim.cmd
local api = vim.api

local M = {}

local config = {
	custom_conversion = {},
}

local function write_to_buf(bufnr, start_row, end_row, last_column_length, output)
	api.nvim_buf_set_text(bufnr, start_row - 1, 0, end_row - 1, last_column_length, output)
end

local function convert_lines(lines, conversion)
	local result = {}
	if conversion.before then
		local before = conversion.before(lines)
		if before ~= nil then
			table.insert(result, before)
		end
	end

	local line_count = 0
	for _ in ipairs(lines) do
		line_count = line_count + 1
	end

	for line_no, line in ipairs(lines) do
		local converted = conversion.convert(line, line_no, line_count)
		if converted ~= nil then
			table.insert(result, converted)
		end
	end

	if conversion.after then
		local after = table.insert(result, conversion.after(lines))
		if after ~= nil then
			table.insert(result, after)
		end
	end

	return result
end

function M.setup(user_options)
	config = vim.tbl_deep_extend("force", config, user_options)

	cmd([[command! -range  -nargs=1 StrDeco :lua require("strdeco").convert_selected_area(<line1>,<line2>,"<args>")]])
end

function M.convert_selected_area(range_start_row, range_end_row, conversion_name)
	local start_row, end_row
	local bufnr = 0 -- current buffer
	if range_start_row == nil or range_end_row == nil then
		local row = buffer.get_current_row()
		start_row, end_row = row, row
	else
		start_row, end_row = range_start_row, range_end_row
	end
	if start_row <= 0 or end_row <= 0 then
		error("invalid range" .. start_row .. "," .. end_row)
		return
	end

	local target_lines = buffer.get_lines(bufnr, start_row, end_row)
	local last_column_length = buffer.get_row_column_length(bufnr, end_row)

	local conversion = config.custom_conversion[conversion_name]
	if conversion == nil then
		conversion = convert.buildins[conversion_name]

		if conversion == nil then
			error("no such conversion method [" .. conversion_name .. "]")
			return
		end
	end

	local output = convert_lines(target_lines, conversion)
	write_to_buf(bufnr, start_row, end_row, last_column_length, output)
end

return M
