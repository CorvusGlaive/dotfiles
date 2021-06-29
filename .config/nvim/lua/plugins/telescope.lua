local actions = require('telescope.actions')

require('telescope').setup {
  defaults = {
    layout_strategy = 'flex',
    -- layout_defaults = {
    --   horizontal = {width_padding = 0.1, height_padding = 0.1, preview_width = 0.6},
    --   vertical = {width_padding = 0.15, height_padding = 0.1, preview_height = 0.6},
    -- },
    prompt_prefix = '> ',
    prompt_position = 'bottom',
    sorting_strategy = 'descending',
    mappings = {
      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      },
      n = { ['<C-c>'] = actions.close },
    },
  },
  extensions = {
    fzf = { override_generic_sorter = true, override_file_sorter = true },
    -- media_files = {
    --   filetypes = { 'png', 'jpg', 'jpeg', 'mp4', 'webm', 'pdf' },
    --   find_cmd = 'fd',
    -- },
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      show_all_buffers = true,
      mappings = {
        i = { ["<c-d>"] = "delete_buffer" },
        n = { ["<c-d>"] = "delete_buffer" },
      },
    },
    find_files = { hidden = true, layout_config = { preview_width = 0.65 } },
  },

}

require('telescope').load_extension('fzf')
require('telescope').load_extension('project')

local M = {}

function M.find_dotfiles()
  require('telescope.builtin').find_files {
    prompt_title = ' Dotfiles ',
    find_command = { 'rg', '--files', '--hidden', '--ignore', '--sort=path' },
    cwd = '~/dotfiles',
  }
end

function M.find_all_files()
  require('telescope.builtin').find_files {
    find_command = { 'rg', '--no-ignore', '--files' },
  }
end

return M
