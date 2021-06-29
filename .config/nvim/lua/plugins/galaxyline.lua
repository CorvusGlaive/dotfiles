local gl = require('galaxyline')
-- get my theme in galaxyline repo
-- local colors = require('galaxyline.theme').default
local colors = {
  bg = '#1f2335',
  -- bg = '#292D38',
  yellow = '#DCDCAA',
  dark_yellow = '#D7BA7D',
  cyan = '#4EC9B0',
  green = '#a1cf8f',
  light_green = '#B5CEA8',
  string_orange = '#CE9178',
  orange = '#FF8800',
  purple = '#d9a8e6',
  magenta = '#fc90c5',
  grey = '#c0caf5',
  blue = '#8cb9de',
  vivid_blue = '#4FC1FF',
  light_blue = '#9CDCFE',
  red = '#ff8787',
  error_red = '#F44747',
  info_yellow = '#FFCC66',
}
local condition = require('galaxyline.condition')
local gls = gl.section
gl.short_line_list = { "vista", "NvimTree", "packer" }

local function cs(section)
  return function(tbl) table.insert(gls[section], tbl) end
end
local left, right = cs("left"), cs("right")

-- Vim section
left {
  ViMode = {
    provider = function()
      -- auto change color according the vim mode
      local mode_color = {
        n = colors.blue,
        i = colors.green,
        v = colors.purple,
        [''] = colors.purple,
        V = colors.purple,
        c = colors.magenta,
        no = colors.blue,
        s = colors.orange,
        S = colors.orange,
        [''] = colors.orange,
        ic = colors.yellow,
        R = colors.red,
        Rv = colors.red,
        cv = colors.blue,
        ce = colors.blue,
        r = colors.cyan,
        rm = colors.cyan,
        ['r?'] = colors.cyan,
        ['!'] = colors.blue,
        t = colors.blue,
      }
      vim.cmd('hi GalaxyViMode guifg=' .. mode_color[vim.fn.mode()])
      return '███ '
    end,
  },
}
--left {
--  SearchCount = {
--    provider = function()
--      local function printf(format, current, total)
--        if current == 0 and total == 0 then
--          return ""
--        end
--        return vim.fn.printf(format, current, total)
--      end

--      local result = vim.fn.searchcount({recompute = 0})
--      if vim.tbl_isempty(result) then
--        return ""
--      end
--      ---NOTE: the search term can be included in the output
--      --- using [%s] but this value seems flaky
--      -- local search_reg = fn.getreg("@/")
--      if result.incomplete == 1 then -- timed out
--        return printf(" ?/?? ")
--      elseif result.incomplete == 2 then -- max count exceeded
--        if result.total > result.maxcount and result.current > result.maxcount then
--          return printf(" >%d/>%d ", result.current, result.total)
--        elseif result.total > result.maxcount then
--          return printf(" %d/>%d ", result.current, result.total)
--        end
--      end
--      return printf(" %d/%d ", result.current, result.total)
--    end
--  }
--}
-- File related section
left {
  CurrentDir = {
    provider = function()
      local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      return "  " .. dir_name .. " "
    end,
    condition = condition.buffer_not_empty,
  },
}

left {
  FileIcon = {
    provider = "FileIcon",
    condition = condition.buffer_not_empty,
    highlight = { require('galaxyline.provider_fileinfo').get_file_icon_color },
  },
}

left {
  FileName = { provider = "FileName", condition = condition.buffer_not_empty },
}

-- Git section
left {
  GitLeftBracket = {
    provider = function() return "" end,
    condition = condition.check_git_workspace,
    highlight = { colors.red },
  },
}
left {
  GitIcon = {
    provider = function() return "" end,
    condition = condition.check_git_workspace,
    highlight = { colors.bg, colors.red },
  },
}

left {
  GitRightBracket = {
    provider = function() return " " end,
    condition = condition.check_git_workspace,
    highlight = { colors.red, "#FFB3B3" },
  },
}

left {
  GitBranch = {
    provider = "GitBranch",
    condition = condition.check_git_workspace,
    highlight = { colors.bg, "#FFB3B3" },
    separator = "",
    separator_highlight = { "#FFB3B3", nil },
  },
}
left {
  DiffAdd = {
    provider = "DiffAdd",
    icon = "  ",
    condition = condition.hide_in_width,
    highlight = { colors.green },
  },
}

left {
  DiffModified = {
    provider = "DiffModified",
    icon = "  ",
    condition = condition.hide_in_width,
    highlight = { colors.blue },
  },
}

left {
  DiffRemove = {
    provider = "DiffRemove",
    icon = "  ",
    condition = condition.hide_in_width,
    highlight = { colors.red },
  },
}

---- RIGHT SECTION
-- LSP
right {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = { colors.error_red },
  },
}
right {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = { colors.orange },
  },
}

right {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = '  ',
    highlight = { colors.vivid_blue },
  },
}
right {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    highlight = { colors.info_yellow },
  },
}

right {
  lsp_status = {
    provider = function()
      local clients = vim.lsp.get_active_clients()
      if next(clients) ~= nil then
        return " " .. "  " .. " LSP "
      else
        return ""
      end
    end,
    -- highlight = { colors.grey },
  },
}

right {
  line_percentage = {
    provider = function()
      local current_line = vim.fn.line(".")
      local total_line = vim.fn.line("$")

      if current_line == 1 then
        return "  Top "
      elseif current_line == vim.fn.line("$") then
        return "  Bot "
      end
      local result, _ = math.modf((current_line / total_line) * 100)
      return "  " .. result .. "% "
    end,
    highlight = { colors.green },
  },
}

right {
  LineInfo = {
    provider = function()
      local line = vim.fn.line(".")
      local col = vim.fn.col(".")

      return string.format("[%d:%d]",line,col)
    end,
    -- highlight = { colors.grey }
  },
}

right {
  BufferType = {
    provider = 'FileTypeName',
    condition = condition.hide_in_width,
    separator = " ",
    -- highlight = { colors.grey },
  },
}
