return {
	{
		"ramilito/kubectl.nvim",
		-- use a release tag to download pre-built binaries
		version = '2.*',
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		dependencies = "saghen/blink.download",
		opts = {},
		keys = {
			{ '<leader>k', '<cmd>lua require("kubectl").toggle()<cr>' },
			{ '<C-k>',     '<Plug>(kubectl.kill)',                    ft = 'k8s_*' },
			{ '7',         '<Plug>(kubectl.view_nodes)',              ft = 'k8s_*' },
			{ '8',         '<Plug>(kubectl.view_overview)',           ft = 'k8s_*' },
			{ '<C-t>',     '<Plug>(kubectl.view_top)',                ft = 'k8s_*' },
		},
	},
}
