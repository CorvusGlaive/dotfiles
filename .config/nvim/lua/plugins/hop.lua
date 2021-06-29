local map = require("keymaps")
map('n', 's', ":HopChar2<cr>")
map('n', 'S', ":HopWord<cr>")
return require("hop").setup({})