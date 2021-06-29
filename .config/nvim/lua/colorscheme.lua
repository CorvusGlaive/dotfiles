---@diagnostic disable: undefined-global
local a = vim.api
local au = require("autocmds")
local lush = require("lush")
local hsl = lush.hsl

local function co(color, amount)
  if vim.o.background == "dark" then
    return hsl(color).li(amount).de(amount)
  end
  return hsl(color).da(amount).sa(amount)
end

local function hi(group, c)
  c.bg = c.bg and ("guibg=" .. c.bg) or ""
  c.fg = c.fg and ("guifg=" .. c.fg) or ""
  c.gui = c.gui and ("gui=" .. c.gui) or ""
  c.sp = c.sp and ("guisp=" .. c.sp) or ""
  local hilight = string.format("hi %s %s %s %s %s", group, c.bg, c.fg, c.gui,
                                c.sp)
  vim.defer_fn(function() vim.cmd(hilight) end, 100)
end

function setColorscheme()
  local hilight = a.nvim_get_hl_by_name("Normal", "")
  local r = {}

  for k, v in pairs(hilight) do
    if k == "background" then k = "bg" end
    if k == "foreground" then k = "fg" end

    if type(v) == "number" then
      v = string.format("%x", v)
      v = "#" .. string.rep("0", 6 - #v) .. v
      r[k] = v
    end
  end

  local theme = lush(function()
    return {
      VertSplit { bg = r.bg, fg = co(r.bg, 5) },

      SignColumn { bg = r.bg },
      LineNr { bg = r.bg },

      NvimTreeNormal { bg = co(r.bg, 5) },
      NvimTreeVertSplit { bg = NvimTreeNormal.bg, fg = NvimTreeNormal.bg },
      NvimTreeStatusLineNC { bg = NvimTreeNormal.bg },

      StatusLine { bg = r.bg },
      StatusLineNC { gui = "underline", fg = co(r.bg, 5), bg = r.bg },
    }
  end)

  for k, v in pairs(theme) do hi(k, v) end
end

au { _colorscheme = { { "ColorScheme", "*", "lua setColorscheme()" } } }
