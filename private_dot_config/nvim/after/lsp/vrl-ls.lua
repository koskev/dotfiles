return {
	--cmd = vim.lsp.rpc.connect("127.0.0.1", 4874),
	cmd = { "vrl-ls" },
	filetypes = { 'vrl' },
	single_file_support = true,
}
