local function enable_all_lsps()
	vim.api.nvim_create_autocmd('LspAttach', {
		desc = 'LSP actions',
		callback = function(event)
			local opts = { buffer = event.buf }

			vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
			vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
			vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
			vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
			vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
			vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
			vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
			vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
			vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
			vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
		end,
	})

	local lsp_configs = {}

	-- XXX: Since the lsp config starts to get infested with AI bullshit, we can't just blindly enable all LSPs T_T FUCK YOU AI!!
	-- for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
	local current_file = debug.getinfo(1, "S").source:sub(2)
	local current_dir = vim.fn.fnamemodify(current_file, ":h")
	for _, f in pairs(vim.split(vim.fn.glob(current_dir .. '/after/lsp/*.lua', true), '\n', {trimempty=true})) do
		local server_name = vim.fn.fnamemodify(f, ':t:r')
		table.insert(lsp_configs, server_name)
	end

	vim.lsp.enable(lsp_configs)
end

vim.g.mapleader = " "



require('config.lazy')
require("set")

enable_all_lsps()
