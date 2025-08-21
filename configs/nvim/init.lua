local function enable_all_lsps()
	local lsp_configs = {}

	for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
		local server_name = vim.fn.fnamemodify(f, ':t:r')
		table.insert(lsp_configs, server_name)
	end

	vim.lsp.enable(lsp_configs)
end

vim.g.mapleader = " "



require('config.lazy')
require("remaps")
require("set")

enable_all_lsps()
