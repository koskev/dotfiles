return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },

	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()
		local conf = require("telescope.config").values
		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end

			require("telescope.pickers").new({}, {
				prompt_title = "Harpoon",
				finder = require("telescope.finders").new_table({
					results = file_paths,
				}),
				previewer = conf.file_previewer({}),
				sorter = conf.generic_sorter({}),
			}):find()
		end

		vim.keymap.set("n", "<leader>hx", function() harpoon:list():add() end, { desc = "Harpoon mark" })
		vim.keymap.set("n", "<leader>hl", function() toggle_telescope(harpoon:list()) end,
			{ desc = "Harppon list" })


		vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon select 1" })
		vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon select 2" })
		vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon select 3" })
		vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon select 4" })
	end
}
