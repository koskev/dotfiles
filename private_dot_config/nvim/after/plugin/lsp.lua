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

--vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
--vim.api.nvim_create_autocmd("LspAttach", {
--  group = "LspAttach_inlayhints",
--  callback = function(args)
--    if not (args.data and args.data.client_id) then
--      return
--    end
--
--    local bufnr = args.buf
--    local client = vim.lsp.get_client_by_id(args.data.client_id)
--    require("lsp-inlayhints").on_attach(client, bufnr)
--  end,
--})


--lspconfig.tsserver.setup({
--  settings = {
--    typescript = {
--      inlayHints = {
--        includeInlayParameterNameHints = 'all',
--        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
--        includeInlayFunctionParameterTypeHints = true,
--        includeInlayVariableTypeHints = true,
--        includeInlayPropertyDeclarationTypeHints = true,
--        includeInlayFunctionLikeReturnTypeHints = true,
--        includeInlayEnumMemberValueHints = true,
--      }
--    },
--    javascript = {
--      inlayHints = {
--        includeInlayParameterNameHints = 'all',
--        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
--        includeInlayFunctionParameterTypeHints = true,
--        includeInlayVariableTypeHints = true,
--        includeInlayPropertyDeclarationTypeHints = true,
--        includeInlayFunctionLikeReturnTypeHints = true,
--        includeInlayEnumMemberValueHints = true,
--      }
--    }
--  }
--})

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


--require("lspconfig").gopls.setup({
--  settings = {
--    hints = {
--      rangeVariableTypes = true,
--      parameterNames = true,
--      constantValues = true,
--      assignVariableTypes = true,
--      compositeLiteralFields = true,
--      compositeLiteralTypes = true,
--      functionTypeParameters = true,
--    },
--  }
--})

require("lspconfig").lua_ls.setup({
  settings = {
    Lua = {
      hint = {
        enable = true, -- necessary
      }
    }
  }
})
