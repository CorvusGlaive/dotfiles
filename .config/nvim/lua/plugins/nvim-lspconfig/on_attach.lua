local map = require("keymaps")
local nmap = function(lhs, rhs, opts)
  map('n', lhs, '<cmd>lua  ' .. rhs .. '<CR>', opts, "buffer")
end

local function mappings()
  nmap('K', 'require("lspsaga.hover").render_hover_doc()')
  nmap('gd', 'vim.lsp.buf.definition()')
  nmap('gD', 'vim.lsp.buf.declaration()')
  nmap('gi', 'vim.lsp.buf.implementation()')
  nmap('gr', 'vim.lsp.buf.references()')
  nmap('ca', 'vim.lsp.buf.code_action()')
  nmap('[d', 'require"lspsaga.diagnostic".lsp_jump_diagnostic_prev()')
  nmap(']d', 'require"lspsaga.diagnostic".lsp_jump_diagnostic_next()')
  nmap("<C-f>", "require('lspsaga.action').smart_scroll_with_saga(1)<CR>")
  nmap("<C-b>", "require('lspsaga.action').smart_scroll_with_saga(-1)<CR>")
  -- map("i","<C-k>", "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>",nil,"buffer")

  require("which-key").register {
    ["gd"] = "lsp: go to definition",
    ["gD"] = "lsp: go to declaration",
    ["gi"] = "lsp: go to implementation",
    ["gr"] = "lsp: find references",
    ["ca"] = "lsp: code action",
    ["[d"] = "lsp: go to prev diagnostic",
    ["]d"] = "lsp: go to next diagnostics"
  }
end
return function(client)

  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

  mappings()

  require("lsp_signature").on_attach()

  if client.name ~= 'efm' then
    client.resolved_capabilities.document_formatting = false
  end

  if client.name == 'typescript' then require('nvim-lsp-ts-utils').setup {} end

--   if client.resolved_capabilities.document_formatting then
--     vim.cmd [[autocmd! BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)]]
--   end

end
