local install_path = vim.fn.stdpath('data') ..
                         '/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({
    "git",
    'clone',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
end
vim.cmd "packadd packer.nvim | au BufWritePost */plugins/*.lua PackerCompile"
-- vim.cmd [[set rtp+=~/.local/share/nvim/site/pack/packer/opt/*]]

local packer = require("packer")
packer.init {
  compile_path = vim.fn.stdpath("data") .. "/site/plugin/packer_compiled.vim",
  opt_default = true,
}

local function packadd(plugin)
  plugin = string.match(plugin, "/(.+)")
  local plugin_prefix = vim.fn.stdpath("data") .. "/site/pack/packer/opt/"

  local plugin_path = plugin_prefix .. plugin .. "/"
  -- print('test '..plugin_path)
  local ok, err, code = os.rename(plugin_path, plugin_path)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  -- print(ok, err, code)
  if ok then
    vim.cmd("packadd! " .. plugin)

    plugin = string.gsub(plugin, "%..+", "")
    pcall(require, "plugins." .. plugin)
  end
  return ok, err, code
end

local function plug(plugin)
  packer.use(plugin)
  local reqs = plugin.requires

  if (type(plugin) == "string") then return packadd(plugin) end

  if type(reqs) == "string" then
    packadd(reqs)
  elseif type(reqs) == "table" then
    for _, r in ipairs(reqs) do packadd(r) end
  end

  for _, p in ipairs(plugin) do
    if type(p) == "table" then
      packadd(p[1])
    else
      packadd(p)
    end
  end

end

return packer.startup(function()
  plug "wbthomason/packer.nvim"

  -- Dependencies
  plug {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim", -- util library
    "rktjmp/lush.nvim", -- colorscheme creation aid
    "kyazdani42/nvim-web-devicons",
    "famiu/bufdelete.nvim",
  }

  -- Lsp
  plug {
    "kabouzeid/nvim-lspinstall",
    "neovim/nvim-lspconfig",
    "glepnir/lspsaga.nvim",
    "folke/trouble.nvim",
    "jose-elias-alvarez/nvim-lsp-ts-utils",
    "ray-x/lsp_signature.nvim",
  }

  -- Autopairs
  plug "windwp/nvim-autopairs"
  plug "yamatsum/nvim-cursorline"

  -- Autocomplete
  plug "hrsh7th/nvim-compe"

  -- Colorschemes
  plug {
    "wadackel/vim-dogrun",
    "christianchiarulli/nvcode-color-schemes.vim",
    "arzg/vim-colors-xcode",
    "NLKNguyen/papercolor-theme",
    "chuling/equinusocio-material.vim",
    "sainnhe/sonokai",
    "doums/darcula",
    "norcalli/nvim-base16.lua",
    "folke/tokyonight.nvim",
    "savq/melange",
    "marko-cerovac/material.nvim",
    "bluz71/vim-nightfly-guicolors",
    "rose-pine/neovim",
    "projekt0n/github-nvim-theme",
    "Pocco81/Catppuccino.nvim"
    -- requires = "rktjmp/lush.nvim",
  }

  -- Terminal
  plug "akinsho/nvim-toggleterm.lua"

  -- Status Line and Bufferline
  plug {
    "glepnir/galaxyline.nvim",
    -- "romgrk/barbar.nvim",
    "akinsho/nvim-bufferline.lua",
    -- requires = { "kyazdani42/nvim-web-devicons", "famiu/bufdelete.nvim" },
  }

  -- Navigation and helpers
  plug "folke/which-key.nvim"
  plug "mbbill/undotree"
  plug "AndrewRadev/splitjoin.vim"

  -- Comments
  plug "tpope/vim-commentary"

  -- Telescope
  plug {
    "nvim-telescope/telescope.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    "nvim-telescope/telescope-project.nvim",
    -- requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
  }

  -- Explorer
  plug "kyazdani42/nvim-tree.lua"

  -- Treesitter
  plug {
    { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
    "windwp/nvim-ts-autotag",
    "p00f/nvim-ts-rainbow",
    "JoosepAlviste/nvim-ts-context-commentstring",
  }

  -- Git
  plug {
    "tpope/vim-fugitive",
    "lewis6991/gitsigns.nvim",
    "sindrets/diffview.nvim",
    -- requires = "nvim-lua/plenary.nvim",
  }
  -- Indentline
  plug { "lukas-reineke/indent-blankline.nvim" }

  -- Others
  plug "phaazon/hop.nvim" -- easymotion
  plug "norcalli/nvim-colorizer.lua" -- highlight colors
  plug "tweekmonster/startuptime.vim"
  -- Symbols
  plug "simrat39/symbols-outline.nvim"
  plug "liuchengxu/vista.vim"

end)
