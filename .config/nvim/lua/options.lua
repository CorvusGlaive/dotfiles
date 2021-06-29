local opt = vim.opt

-- Search
opt.inccommand = "split"
opt.ignorecase = true
opt.smartcase = true

opt.hidden = true
opt.title = true
opt.titlestring = "%<%F%=%l/%L - nvim"
opt.wrap = false
opt.whichwrap = opt.whichwrap + "<,>,[,],h,l"
opt.mouse = "a"
opt.termguicolors = true

opt.ts = 2
opt.sw = 2
opt.expandtab = true

opt.number = true
opt.relativenumber = true

opt.completeopt = "menuone,noselect"
opt.pumheight = 10
opt.pumblend = 10

opt.backup = false
opt.writebackup = false
opt.swapfile = false

opt.cursorline = true
opt.showtabline = 2
opt.showmode = false
opt.updatetime = 100
opt.timeoutlen = 500
opt.signcolumn = "yes:2"
opt.clipboard = "unnamedplus"
opt.scrolloff = 10
opt.sidescrolloff = 10

opt.shortmess = opt.shortmess + "c"

vim.cmd "syntax on"

