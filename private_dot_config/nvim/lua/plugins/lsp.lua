local function setup_lsp(name, config)
	if vim.version().minor >= 11 then
		vim.lsp.enable(name)
		vim.lsp.config(name, config)
	else
		require('lspconfig')[name].setup(config)
	end
end
-- All lsp related config. mason-lspconfig initializes all lsps.
-- See https://lsp-zero.netlify.app/docs/tutorial.html
return {
	{
		"williamboman/mason-lspconfig.nvim",
		event = "VeryLazy",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
			-- Add cmp_nvim_lsp capabilities settings to lspconfig
			-- This should be executed before you configure any language server
			local lspconfig_defaults = require('lspconfig').util.default_config
			local status, blink_cmp = pcall(require, "blink.cmp")

			if status then
				lspconfig_defaults.capabilities = blink_cmp.get_lsp_capabilities(lspconfig_defaults
					.capabilities)
			end
			require('mason').setup({})

			local manual_ls_config = {}

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


			-- Goimports on save
			-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				callback = function()
					local params = vim.lsp.util.make_range_params()
					params.context = { only = { "source.organizeImports" } }
					-- buf_request_sync defaults to a 1000ms timeout. Depending on your
					-- machine and codebase, you may want longer. Add an additional
					-- argument after params if you find that you have to write the file
					-- twice for changes to be saved.
					-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
					local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
					for cid, res in pairs(result or {}) do
						for _, r in pairs(res.result or {}) do
							if r.edit then
								local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
								vim.lsp.util.apply_workspace_edit(r.edit, enc)
							end
						end
					end
					vim.lsp.buf.format({ async = false })
				end
			})


			local util = require 'lspconfig.util'

			local root_dirs = {}
			require('lspconfig.configs').rjsonnet = {
				default_config = {
					cmd = { 'env', 'RUST_LOG=debug', 'rjsonnet' },
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
			--lspconfig.rjsonnet.setup({})

			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_enable = {
					exclude = manual_ls_config
				},
				handlers = {
					-- this first function is the "default handler"
					-- it applies to every language server without a "custom handler"
					function(server_name)
						setup_lsp(server_name, {})
					end
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
				--				"jsonnet_ls",
				"jedi_language_server",
				-- Debugger
				"delve",
				-- Formatter
				"goimports",
				"gomodifytags",
				"jsonnetfmt",
				-- Other tools
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
					null_ls.builtins.formatting.packer,


				}
			})
		end
	},
}
