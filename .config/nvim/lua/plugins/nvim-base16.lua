local base = require("base16")
local map = require("keymaps")

local idx = 0
local themes = base.theme_names()
table.sort(themes)
function base16_cycle(dir)
  idx = idx % #themes + dir
  base(base.themes[themes[idx]], true)
  print(tostring(themes[idx]), tostring(idx) .. "/" .. tostring(#themes))
end

map("n", "<leader>tj", ":lua base16_cycle(-1)<CR>")
map("n", "<leader>tk", ":lua base16_cycle(1)<CR>")

require("colorscheme")
-- require("base16")(require("base16").themes["onedark"],true)

