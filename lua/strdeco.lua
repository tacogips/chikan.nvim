local lib = require("strdeco_lib")

local cmd = vim.cmd

----local result = lib.convert({ "some" })
--
--for k, v in ipairs(result) do
--	print("---", k, v)
--end

local M = {}

local config = {
	cmds = {
		julia = "julia",
	},
}

function M.setup(user_options)
	config = vim.tbl_deep_extend("force", config, user_options)

	cmd(
		[[command! -range JumpToGithub :<line1>,<line2>lua require("jump_to_github").jump_current_lines(<line1>,<line2>)]]
	)
end

function M.convert_selected_area(range_start_raw, range_end_row)
	if range_start_row == nil or range_end_row == nil then
		local row = buffer.get_current_row()
		start_row, end_row = row, row
	else
		start_row, end_row = range_start_row, range_end_row
	end
end

return M
