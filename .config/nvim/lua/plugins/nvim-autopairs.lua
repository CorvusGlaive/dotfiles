local npairs = require('nvim-autopairs')
local map = require("keymaps")

-- Tab completion confirm
_G.utils = {}
vim.g.completion_confirm_key = ""

utils.completion_confirm = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info()["selected"] ~= -1 then
      return vim.fn["compe#confirm"](npairs.esc("<cr>"))
    else
      return npairs.esc("<cr>")
    end
  else
    return npairs.autopairs_cr()
  end
end


npairs.setup({})
