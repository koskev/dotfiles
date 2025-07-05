return {
	{
		"folke/snacks.nvim",
		---@type snacks.Config
		opts = {
			input = {
				-- your input configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			},
			notifier = {},
			dashboard = {
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					{ pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1, cwd = true },
					{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
					{
						pane = 2,
						icon = " ",
						title = "Git Status",
						section = "terminal",
						enabled = function()
							return Snacks.git.get_root() ~= nil
						end,
						cmd = "git status --short --branch --renames",
						height = 5,
						padding = 1,
						ttl = 5 * 60,
						indent = 3,
					},
					{ section = "startup" },
				},
			}
		}
	}
}
