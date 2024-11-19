return {
  {
    'airblade/vim-gitgutter',
  },
  {
    "f-person/git-blame.nvim",
    -- load the plugin at startup
    event = "VeryLazy",
    -- Because of the keys part, you will be lazy loading this plugin.
    -- The plugin wil only load once one of the keys is used.
    -- If you want to load the plugin at startup, add something like event = "VeryLazy",
    -- or lazy = false. One of both options will work.
    opts = {
      -- your configuration comes here
      -- for example
      enabled = false, -- if you want to enable the plugin
      message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
      date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
      virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
    },
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },
  {
    'ThePrimeagen/git-worktree.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require("telescope").load_extension("git_worktree")

      vim.keymap.set("n", "<leader>gw", ":lua require('telescope').extensions.git_worktree.git_worktrees()<CR>",
        { silent = true, desc = "Get git Worktrees" })
      vim.keymap.set("n", "<leader>gW", ":lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>",
        { silent = true, desc = "Create git Worktrees" })
    end
  }
}
