local lsp = require('lsp-zero').preset({})
local lspconfig = require("lspconfig")
local cmp = require('cmp')

lsp.ensure_installed({
  'tsserver',
  'rust_analyzer',
})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})


lsp.setup()


local cfg = require("yaml-companion").setup({
  -- Add any options here, or leave empty to use the default settings
  -- lspconfig = {
  --   cmd = {"yaml-language-server"}
  -- },
})
require("lspconfig")["yamlls"].setup(cfg)

require("inlay-hints").setup({
  commands = { enable = true }, -- Enable InlayHints commands, include `InlayHintsToggle`, `InlayHintsEnable` and `InlayHintsDisable`
  autocmd = { enable = true } -- Enable the inlay hints on `LspAttach` event
})

-- https://old.reddit.com/r/neovim/comments/172v2pn/how_to_activate_inlay_hints_for_gopls/
require("lspconfig").gopls.setup({
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

require("lspconfig").lua_ls.setup({
  settings = {
    Lua = {
      hint = {
        enable = true, -- necessary
      },
      diagnostics = {
        globals = {'vim'}
      }
    }
  }
})
