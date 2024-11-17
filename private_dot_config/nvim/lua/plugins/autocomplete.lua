return {
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/cmp-buffer' },
	{ 'hrsh7th/cmp-path' },
	{ 'hrsh7th/cmp-cmdline' },
	{
		'hrsh7th/nvim-cmp',
		dependencies = { "L3MON4D3/LuaSnip" },
		config = function()
			local cmp = require('cmp')

			cmp.setup({
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
				},
				mapping = cmp.mapping.preset.insert({
					-- `Enter` key to confirm completion
					['<CR>'] = cmp.mapping.confirm({ select = true }),

					-- Ctrl+Space to trigger completion menu
					['<C-Space>'] = cmp.mapping.complete(),

					-- Scroll up and down in the completion documentation
					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-d>'] = cmp.mapping.scroll_docs(4),
				}),
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
						-- vim.snippet.expand(args.body)
					end,
				},
			})
		end
	},
}
