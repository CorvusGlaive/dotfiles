local map = require("keymaps")

map('n', '<TAB>', ':BufferNext<CR>')
map('n', '<S-TAB>', ':BufferPrevious<CR>')
map('n', '<S-x>', ':BufferClose<CR>')
