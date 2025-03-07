-- All lsp related config. mason-lspconfig initializes all lsps.
-- See https://lsp-zero.netlify.app/docs/tutorial.html
return {
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

			lspconfig.ts_ls.setup({
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
							includeInlayParameterNameHintsWhenArgumentMatchesName = true,
							includeInlayVariableTypeHints = true,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHintsWhenTypeMatchesName = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
							includeInlayParameterNameHintsWhenArgumentMatchesName = true,
							includeInlayVariableTypeHints = true,

							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHintsWhenTypeMatchesName = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
				},
			})

			local util = require 'lspconfig.util'

			local root_dirs = {}
			require('lspconfig.configs').rjsonnet = {
				default_config = {
					cmd = { 'rjsonnet' },
					--cmd = vim.lsp.rpc.connect("127.0.0.1", "4874"),
					filetypes = { 'jsonnet', 'libsonnet' },
					single_file_support = false,
					root_dir = function(fname)
						return util.root_pattern 'jsonnetfile.json' (fname)
							or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1]) or "~"
					end,
					before_init = function(initialize_params)
						initialize_params['initializationOptions'] = {
							root_dirs = root_dirs
						}
					end,
					on_new_config = function(_, root_dir)
						local paths = {
							root_dir .. '/lib',
							root_dir .. '/vendor',
						}
						for _, path in ipairs(paths) do
							table.insert(root_dirs, path)
						end
					end,
				},
				docs = {
					description = [[
						Cool new jsonnet ls server
					]],
				},
			}
			lspconfig.rjsonnet.setup({})
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
				"gomodifytags",
				"jsonnetfmt",
			}
		}
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
		},
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					-- Go
					-- Add tags like json to structs
					null_ls.builtins.code_actions.gomodifytags,


				}
			})
		end
	},
}
