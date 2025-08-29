return {
	{
		"L3MON4D3/LuaSnip",
		event = "VeryLazy",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
			local ls = require("luasnip")
			local s = ls.snippet
			local t = ls.text_node
			local fmt = require("luasnip.extras.fmt").fmt
			local rep = require("luasnip.extras").rep
			local i = ls.insert_node
			ls.add_snippets("jsonnet", {
				s(
					"nv",
					fmt([[
					'#{}':: __.val(
						|||
							{}
						|||,
						__.T.{},
						self.{},
						),
						{}: {},
					]]
					, {
						i(1, "Name"),
						i(2, "Description"),
						i(3, "Type"),
						rep(1),
						rep(1),
						i(4, "Default Value"),
					})
				),
				s(
					"nf",
					fmt([[
					'#{}':: __.fn(
						|||
							{}
						|||,
						[

						]
					),
					{}:: {},
					]]
					, {
						i(1, "Name"),
						i(2, "Description"),
						rep(1),
						i(3, "Body"),
					})
				),
				s(
					"na",
					fmt("__.arg('{}', __.T.{}, help='{}'),", { i(1, "Name"), i(2, "type"), i(3, "help text") })
				),
				s(
					"no",
					fmt([[
					'#{}':: __.obj(
					    |||
							{}
					    |||,
						),
						{}: {{{}}},
					]]
					, {
						i(1, "Name"),
						i(2, "Description"),
						rep(1),
						i(3, "Body"),
					})
				),
			})
		end
	},

}
