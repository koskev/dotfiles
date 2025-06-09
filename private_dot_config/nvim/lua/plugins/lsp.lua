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

			table.insert(manual_ls_config, "gopls")

			-- https://old.reddit.com/r/neovim/comments/172v2pn/how_to_activate_inlay_hints_for_gopls/
			lspconfig.gopls.setup({
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

			table.insert(manual_ls_config, "lua_ls")
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

			table.insert(manual_ls_config, "ts_ls")
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

			local function getJson(filename)
				local foundFile = vim.fs.find(filename, { path = vim.loop.cwd(), upward = true, type = "file" })[1]
				if foundFile == nil then
					return nil
				end
				local f = io.open(foundFile, "r")
				if f == nil then
					return nil
				end
				local data = f:read("*all")
				return vim.json.decode(data)
			end

			local function getExtcodeFile()
				local foundFile = vim.fs.find("extcode.libsonnet",
					{ path = vim.loop.cwd(), upward = true, type = "file" })[1]
				if foundFile == nil then
					return nil
				end
				local filename = vim.fs.basename(foundFile)
				local retVal = {}
				retVal[vim.fn.fnamemodify(filename, ":r")] = foundFile
				return retVal
			end

			table.insert(manual_ls_config, "jsonnet_ls")
			lspconfig.jsonnet_ls.setup({
				--cmd = { "/tmp/venv/bin/lsp-devtools", "agent", "--", "jsonnet-language-server" },
				settings = {
					enable_lint_diagnostics = true,
					show_docstring_in_completion = true,
					enable_eval_diagnostics = true,
					--ext_vars = getJson("extvars.json"),
					--ext_code = getJson("extcode.json"),
					ext_code_config = {
						find_upwards = true,
					},
					use_type_in_detail = true,
					enable_semantic_tokens = true,
					inlay_config = {
						enable_debug_ast = false,
						enable_index_value = true,
						enable_function_args = true,
					},
					workarounds = {
						assume_true_condition_on_error = true,
					},
					completion = {
						enable_snippets = true
					}
				}
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
			--
			table.insert(manual_ls_config, "golangci_lint_ls")
			lspconfig.golangci_lint_ls.setup({
				init_options = {
					command = {
						"golangci-lint",
						"run",
						"--output.json.path",
						"stdout",
						"--show-stats=false",
						"--issues-exit-code=1",
					},
				}

			})
			require("mason-lspconfig").setup({
				automatic_enable = {
					exclude = manual_ls_config
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
