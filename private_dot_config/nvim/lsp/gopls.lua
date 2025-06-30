return {
	-- https://old.reddit.com/r/neovim/comments/172v2pn/how_to_activate_inlay_hints_for_gopls/
	--cmd = vim.lsp.rpc.connect("127.0.0.1", "1789"),
	-- cmd = { "/tmp/venv/bin/lsp-devtools", "agent", "--", "gopls" },
	settings = {
		gopls = {
			["ui.semanticTokens"] = true,
			["ui.inlayhint.hints"] = {
				rangeVariableTypes = true,
				parameterNames = true,
				constantValues = true,
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				functionTypeParameters = true,
			},
		},
	},
}
