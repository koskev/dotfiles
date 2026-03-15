return {
	--cmd = vim.lsp.rpc.connect("127.0.0.1", 4874),
	cmd = { "machtnix" },
	filetypes = { 'nix' },
	root_markers = { 'flake.nix', '.git' },
}
