return {
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/cmp-buffer' },
	{ 'hrsh7th/cmp-path' },
	{ 'hrsh7th/cmp-cmdline' },
	-- For lua stuff (including vim stuff)
	{ 'hrsh7th/cmp-nvim-lua' },
	{
		'hrsh7th/nvim-cmp',
		dependencies = { "L3MON4D3/LuaSnip", "onsails/lspkind.nvim" },
		config = function()
			local cmp = require('cmp')
			local lspkind = require('lspkind')
			local luasnip = require("luasnip")

			cmp.setup({
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'nvim_lua' },
					{ name = 'path' },
					{ name = 'luasnip' },
					{ name = 'buffer',  keyword_length = 5 },
				},

				formatting = {
					format = lspkind.cmp_format {
						with_text = true,
						menu = {
							buffer = "[buf]",
							nvim_lsp = "[lsp]",
							nvim_lua = "[api]",
							luasnip = "[snip]",
							path = "[path]"
						}
					}
				},
				experimental = {
					ghost_text = true
				},
				mapping = cmp.mapping.preset.insert({
					-- `Enter` key to confirm completion
					['<CR>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if luasnip.expandable() then
								luasnip.expand()
							else
								cmp.confirm({
									select = true,
								})
							end
						else
							fallback()
						end
					end),

					-- Ctrl+Space to trigger completion menu
					['<C-Space>'] = cmp.mapping.complete(),

					-- Scroll up and down in the completion documentation
					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-d>'] = cmp.mapping.scroll_docs(4),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
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
