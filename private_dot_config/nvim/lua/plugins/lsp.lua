-- All lsp related config. mason-lspconfig initializes all lsps.
-- See https://lsp-zero.netlify.app/docs/tutorial.html
return {
	{
		"MysticalDevil/inlay-hints.nvim",
		event = "LspAttach",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			local lsp = require('lspconfig')
			local inlay = require("inlay-hints")
			inlay.setup({
				commands = { enable = true }, -- Enable InlayHints commands, include `InlayHintsToggle`, `InlayHintsEnable` and `InlayHintsDisable`
				autocmd = { enable = true } -- Enable the inlay hints on `LspAttach` event
			})
			vim.keymap.set("n", "ti", ":InlayHintsToggle<CR>", { desc = "Toggle inlay hints" })
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
			-- Add cmp_nvim_lsp capabilities settings to lspconfig
			-- This should be executed before you configure any language server
			local lspconfig = require("lspconfig")
			local lspconfig_defaults = require('lspconfig').util.default_config
			lspconfig_defaults.capabilities = vim.tbl_deep_extend(
				'force',
				lspconfig_defaults.capabilities,
				require('cmp_nvim_lsp').default_capabilities()
			)

			require('mason').setup({})
			require("mason-lspconfig").setup({
				handlers = {
					-- this first function is the "default handler"
					-- it applies to every language server without a "custom handler"
					function(server_name)
						require('lspconfig')[server_name].setup({})
					end
				}
			})
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

			local cfg = require("yaml-companion").setup({
				-- Add any options here, or leave empty to use the default settings
				-- lspconfig = {
				--   cmd = {"yaml-language-server"}
				-- },
			})
			lspconfig["yamlls"].setup(cfg)

			-- https://old.reddit.com/r/neovim/comments/172v2pn/how_to_activate_inlay_hints_for_gopls/
			lspconfig.gopls.setup({
				settings = {
					gopls = {
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
			})

			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						hint = {
							enable = true, -- necessary
						},
						diagnostics = {
							globals = { 'vim' }
						}
					}
				}
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				-- LSPs
				"rust_analyzer",
				"gopls",
				"helm_ls",
				"yamlls",
				"jsonnet_ls",
				"jedi_language_server",
				-- Debugger
				"delve",
				-- Formatter
				"goimports",
				"jsonnetfmt",
			}
		}
	}
}
