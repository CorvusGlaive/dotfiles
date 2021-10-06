local map = require("keymaps")

map('n', '<S-l>', ':BufferLineCycleNext<CR>')
map('n', '<S-h>', ':BufferLineCyclePrev<CR>')
map('n', '<S-x>', ':Bdelete! %<CR>')

require'bufferline'.setup {
  options = {
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 22,
    max_prefix_length = 15, -- prefix used when a buffer is deduplicated
    tab_size = 25,
    diagnostics = "nvim_lsp",
    -- show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = true,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    separator_style = "thin",
    -- enforce_regular_tabs = false | true,
    always_show_bufferline = true,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "center",
        padding = 1
      }
    },
    -- sort_by = 'extension' | 'relative_directory' | 'directory' | function(buffer_a, buffer_b)
  },
}
