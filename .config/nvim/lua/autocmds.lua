local api = vim.api

---@param definitions table
local function au(definitions)
  for group_name, definition in pairs(definitions) do
    api.nvim_command('augroup ' .. group_name)
    api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten { 'autocmd', def }, ' ')
      api.nvim_command(command)
    end
    api.nvim_command('augroup END')
  end
end

au {
  _general_settings = {
    {
      "TextYankPost",
      "*",
      "lua require('vim.highlight').on_yank({higroup = 'Search', timeout = 200})",
    },
    { "BufWritePre", "*", [[%s/\s\+$//e]] },
    { "BufEnter", "NvimTree", "setlocal signcolumn=no" },
    -- { "BufWritePost", "*.lua", ":luafile %"}
  },
  _lspSagaCursorCommands = {
    {
      "CursorHold",
      "*",
      "lua require('lspsaga.diagnostic').show_cursor_diagnostics()",
    },
  },
}

return au
