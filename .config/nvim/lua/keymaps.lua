local function map(mode, lhs, rhs, opts, scope)
  local options = { noremap = true, silent = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = " "
map("n", "<space>","<NOP>")
map("v","<space>","NOP")

-- Toggle highlight
map("n", "<CR>", '{-> v:hlsearch ? ":nohl\\<CR>" : "\\<CR>"}()', { expr = true })
-- Exit
map("i", "jj", "<ESC>")

-- Terminal
map("t", "<ESC>", [[<C-\><C-n>]])
map("t", '<C-w>h', [[<C-\><C-n><C-W>h]])
map("t", '<C-w>j', [[<C-\><C-n><C-W>j]])
map("t", '<C-w>k', [[<C-\><C-n><C-W>k]])
map("t", '<C-w>l', [[<C-\><C-n><C-W>l]])

-- Center search result
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Change orientation of splitted windows
map("n", "<leader>wv", "<C-W>t <C-W>H")
map("n", "<leader>wh", "<C-W>t <C-W>K")

-- Window movement
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Window resize
map("n", "<C-Up>", ":resize +2<CR>")
map("n", "<C-Down>", ":resize -2<CR>")
map("n", "<C-Left>", ":vertical resize +2<CR>")
map("n", "<C-Right>", ":vertical resize -2<CR>")

-- Indentation
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Yank the rest of the line
map("n", "Y", "yg_")

-- Switch buffers
-- map("n", "<TAB>", ":bnext<CR>")
-- map("n", "<S-TAB>", ":bprevious<CR>")

-- Move selected line / block of text in visual mode
map('x', 'K', ':move \'<-2<CR>gv=gv')
map('x', 'J', ':move \'>+1<CR>gv=gv')

-- Better nav for omnicomplete
map("i", "<C-j>", "<C-n>")
map("i", "<C-k>", "<C-p>")
map("i", "<CR>", "v:lua.utils.completion_confirm()", { expr = true })

-- Save
map( "n", "<C-s>", [[:write<CR>]])

return map
