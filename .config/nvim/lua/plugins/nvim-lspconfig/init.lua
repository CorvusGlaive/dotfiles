local lspconfig = require('lspconfig')
local lspinstall = require('lspinstall')
local languages = require('plugins.nvim-lspconfig.format')
local on_attach = require('plugins.nvim-lspconfig.on_attach')
local DATA_PATH = vim.fn.stdpath('data')

require("vim.lsp.protocol").CompletionItemKind = {
  " Text", -- Text
  " Method", -- Method
  "ƒ Function", -- Function
  " Constructor", -- Constructor
  "識 Field", -- Field
  " Variable", -- Variable
  " Class", -- Class
  "ﰮ Interface", -- Interface
  " Module", -- Module
  " Property", -- Property
  " Unit", -- Unit
  " Value", -- Value
  "了 Enum", -- Enum
  " Keyword", -- Keyword
  " Snippet", -- Snippet
  " Color", -- Color
  " File", -- File
  "渚 Reference", -- Reference
  " Folder", -- Folder
  " Enum", -- Enum
  " Constant", -- Constant
  " Struct", -- Struct
  "鬒 Event", -- Event
  "\u{03a8} Operator", -- Operator
  " Type Parameter", -- TypeParameter
}
vim.fn.sign_define({
  {
    name = "LspDiagnosticsSignError",
    text = "",
    texthl = "LspDiagnosticsSignError",
  },
  {
    name = "LspDiagnosticsSignHint",
    text = "",
    texthl = "LspDiagnosticsSignHint",
  },
  {
    name = "LspDiagnosticsSignWarning",
    text = "",
    texthl = "LspDiagnosticsSignWarning",
  },
  {
    name = "LspDiagnosticsSignInformation",
    text = "",
    texthl = "LspDiagnosticsSignInformation",
  },
})

vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                 {
      underline = true,
      virtual_text = true,
      signs = true,
      update_in_insert = false,
    })

local servers = {
  efm = {
    init_options = { documentFormatting = true, codeAction = true },
    root_dir = lspconfig.util.root_pattern({ '.git/', '.' }),
    filetypes = vim.tbl_keys(languages),
    settings = { languages = languages, log_level = 1, log_file = '~/efm.log' },
  },
  lua = {
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim', 'packer_plugins' } },
        completion = { keywordSnippet = 'Both' },
        runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            ["/usr/share/awesome/lib"] = true,
          },
        },
      },
    },
  },
  -- cpp = {
  --   cmd = {DATA_PATH .. "/lspinstall/cpp/clangd/bin/clangd"},
  --   on_attach = require'lsp'.common_on_attach,
  --   handlers = {
  --     ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  --       virtual_text = {spacing = 0, prefix = ""},
  --       signs = true,
  --       underline = true,
  --       update_in_insert = true
  --     })
  --   }
  -- }
}

local function setup_servers()
  lspinstall.setup()
  local installed = lspinstall.installed_servers()
  for _, server in pairs(installed) do
    local config = servers[server] or
                       {
          root_dir = lspconfig.util.root_pattern({ '.git/', '.' }),
        }
    config.on_attach = on_attach
    -- print(tostring(server), vim.inspect(lspconfig[server]))
    lspconfig[server].setup(config)
  end
end

setup_servers()
