local function getCommand()
	local filename = vim.api.nvim_buf_get_name(0)
	local root_dir = vim.fs.dirname(vim.fs.find('.git', { path = filename, upward = true })[1])
	local cmd = {}
	table.insert(cmd, "jsonnet")
	if root_dir ~= nil then
		return cmd
	end
	local paths = {
		root_dir,
		root_dir .. '/lib',
		root_dir .. '/vendor',
	}
	for _, path in ipairs(paths) do
		table.insert(cmd, "-J")
		table.insert(cmd, path)
	end
	return cmd
end

return {
	'https://gitlab.com/itaranto/preview.nvim',
	version = '*',
	opts = {
		previewers_by_ft = {
			jsonnet = {
				name = "jsonnet",
				--renderer = { type = "command", opts = { cmd = getCommand(), } },
				renderer = { type = "command", opts = { cmd = { "jsonnet" }, } },
			}
		},
		previewers = {
			jsonnet = {
				args = { "" }
			}
		}
	},
}
