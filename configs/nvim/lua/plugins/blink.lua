return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		enabled = true,
		event = "VeryLazy",
		'saghen/blink.cmp',
		-- optional: provides snippets for the snippet source
		dependencies = {
			'rafamadriz/friendly-snippets',
			-- feat etc. completion
			'disrupted/blink-cmp-conventional-commits',
			-- Complete scopes in conventional_commits
			{ 'koskev/csc.nvim', opts = {} },
			"MahanRahmati/blink-nerdfont.nvim",
		},

		-- use a release tag to download pre-built binaries
		version = '1.*',
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = {
				preset = 'enter',
			},
			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = 'mono'
			},

			completion = {
				accept = { auto_brackets = { enabled = false }, },
				documentation = {
					auto_show = true
				},
				ghost_text = { enabled = true },
				list = {
					selection = {
						preselect = true, auto_insert = false
					}
				},
				menu = {
					draw = {
						columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 }, { "source_name" } },
					}
				}
			},

			signature = { enabled = true },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = {
					"lazydev",
					'lsp',
					'path',
					'snippets',
					'conventional_commits',
					'csc',
					'buffer',
					--"nerdfont",
				},
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
					snippets = {
						min_keyword_length = 2,
						score_offset = 10,
						should_show_items = function(ctx)
							return ctx.trigger.initial_kind ~= 'trigger_character' and
								not require('blink.cmp').snippet_active()
						end,
					},
					conventional_commits = {
						name = 'Conventional Commits',
						module = 'blink-cmp-conventional-commits',
						enabled = function()
							return true
							-- return vim.bo.filetype == 'gitcommit'
						end,
						---@module 'blink-cmp-conventional-commits'
						---@type blink-cmp-conventional-commits.Options
						opts = {}, -- none so far
					},
					csc = {
						name = 'CSC',
						module = 'csc.blink-cmp',
						enabled = function()
							return vim.bo.filetype == 'gitcommit'
						end,
						opts = {},
					},
					nerdfont = {
						module = "blink-nerdfont",
						name = "Nerd Fonts",
						score_offset = 15, -- Tune by preference
						opts = { insert = true }, -- Insert nerdfont icon (default) or complete its name
					}
				},
			},
			snippets = { preset = 'luasnip' },


			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" }
		},
		opts_extend = { "sources.default" }
	}
}
