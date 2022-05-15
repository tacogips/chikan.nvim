local M = {}

local function to_snake_case(line)
	line = string.gsub(line, "%s+", function()
		return "_"
	end)

	line = string.gsub(line, "(%u)", function(s)
		return "_" .. s
	end)

	line = string.gsub(line, "^%s*(%u+)", function(s)
		return string.lower(s)
	end)

	line = string.gsub(line, "_*(%u+)", function(s)
		return "_" .. string.lower(s)
	end)

	line = string.gsub(line, "^_", function()
		return ""
	end)

	return line
end

local function to_upper_snake_case(line)
	return string.upper(to_snake_case(line))
end

local function to_camel_case(line)
	line = string.gsub(line, "%s+(.)", function(s)
		return string.upper(s)
	end)

	line = string.gsub(line, "^%s*(.)", function(s)
		return string.lower(s)
	end)

	line = string.gsub(line, "_+(.)", function(s)
		return string.upper(s)
	end)
	return line
end

local function to_json_field(line, line_no, line_count)
	if line == "" then
		return nil
	end
	line = string.gsub(line, "^%s*(.)", function(s)
		return '   "' .. s
	end)

	line = string.gsub(line, "(.)%s*$", function(s)
		local field = s .. '" : ""'
		if line_no == line_count then
			return field
		else
			return field .. ","
		end
	end)
	return line
end

M.buildins = {
	to_snake_case = { before = nil, convert = to_snake_case, after = nil },
	to_upper_snake_case = { before = nil, convert = to_upper_snake_case, after = nil },
	to_camel_case = { before = nil, convert = to_camel_case, after = nil },
	to_json = {
		before = function()
			return "{"
		end,
		convert = to_json_field,
		after = function()
			return "}"
		end,
	},
}

return M
