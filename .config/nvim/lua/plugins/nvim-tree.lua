vim.g.nvim_tree_hide_dotfiles = 0
vim.g.nvim_tree_indent_markers = 0
vim.g.nvim_tree_ignore = { ".git", "node_modules" }

local tree_cb = require'nvim-tree.config'.nvim_tree_callback

require("nvim-tree").setup {
  open_on_setup = true,
  update_focused_file = { enable = true },
  view = {
    auto_resize = true,
    mappings = {
      list = {
        { key = "l", cb = tree_cb("edit") },
        { key = "h", cb = tree_cb("close_node") },
      },
    },
  },
}
