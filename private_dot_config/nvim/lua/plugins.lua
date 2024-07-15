local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- My plugins here
  use 'airblade/vim-gitgutter'
  
  -- Multi-entry selection UI. FZF
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'
  -- use 'Shougo/deoplete.nvim'
  -- Python complete
  -- use 'deoplete-plugins/deoplete-jedi'
  -- Display signature bottom
  use 'Shougo/echodoc.vim'
  use 'rhysd/vim-clang-format'
  use 'farmergreg/vim-lastplace'
  use 'editorconfig/editorconfig-vim'
  -- Shell syntax check
  use 'dense-analysis/ale'
  -- GLSL
  use 'tikhomirov/vim-glsl'
  -- Yank history
  use 'svermeulen/vim-yoink'
  -- Autoformat plugin for all languages
  use 'vim-autoformat/vim-autoformat'
  use 'mhinz/vim-crates'
  use 'simrat39/rust-tools.nvim'
  use 'neovim/nvim-lspconfig'

  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  use 'mfussenegger/nvim-dap' -- for debugging
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} } -- debugging gui
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { {'nvim-lua/plenary.nvim'} } }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  require'lspconfig'.rust_analyzer.setup{}
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

