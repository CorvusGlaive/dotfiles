vim.g.nvim_tree_hide_dotfiles = 0
vim.g.nvim_tree_indent_markers = 0
vim.g.nvim_tree_follow = 1
vim.g.nvim_tree_auto_open = 1
vim.g.nvim_tree_ignore = { ".git", "node_modules" }

local tree_cb = require'nvim-tree.config'.nvim_tree_callback
vim.g.nvim_tree_bindings = {
  { key = "l", cb = tree_cb("edit") },
  { key = "h", cb = tree_cb("close_node") },
}
