-- mesopic.nvim
--
--   :colorscheme mesopic     -- night
--   :colorscheme photopic    -- day
--   :checkhealth mesopic     -- measure the live palette
--
-- Colours are stored in OKLCH and converted at load, so `intensity` and
-- `contrast` are perceptual knobs rather than hex nudging. README separates
-- what is evidence from what is judgement, including the research that
-- argues against dark mode.

local config     = require("mesopic.config")
local palette    = require("mesopic.palette")
local highlights = require("mesopic.highlights")
local plugins    = require("mesopic.groups.plugins")
local terminal   = require("mesopic.groups.terminal")

local M = {}

---@param opts MesopicOptions|nil
function M.setup(opts)
  config.setup(opts)
end

---@param variant "night"|"day"|nil
function M.load(variant)
  if vim.g.colors_name then
    vim.cmd("highlight clear")
  end
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true

  local v = variant or config.variant()
  vim.o.background  = (v == "day") and "light" or "dark"
  vim.g.colors_name = (v == "day") and "photopic" or "mesopic"

  local o = config.options
  local c = palette.build(v, o)

  local groups = vim.tbl_extend("force",
    highlights.get(c, o),
    plugins.get(c, o),
    o.overrides
  )

  for group, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  if o.terminal_colors then
    terminal.setup(c)
  end

  vim.api.nvim_exec_autocmds("ColorScheme", { pattern = vim.g.colors_name })
end

--- Swap night and day without restarting.
function M.toggle()
  M.load(vim.g.colors_name == "photopic" and "night" or "day")
end

--- Turn focus mode on or off live. In focus, colour marks only what needs
--- attention: diagnostics, git state, control flow. Everything else goes quiet.
---@param on boolean|nil toggles when omitted
function M.focus(on)
  if on == nil then on = not config.options.focus end
  config.options.focus = on
  M.load()
end

--- The built palette for a variant, e.g. for a custom statusline.
---@param variant "night"|"day"|nil
---@return table<string,string>
function M.palette(variant)
  return palette.build(variant or config.variant(), config.options)
end

--- Measured contrast of every role against the background.
---@param variant "night"|"day"|nil
---@return table<string,number>
function M.audit(variant)
  return palette.audit(M.palette(variant))
end

--- lualine theme:
---   require("lualine").setup { options = { theme = require("mesopic").lualine() } }
function M.lualine()
  local c = M.palette()
  local mid  = { fg = c.punct, bg = c.surface }
  local tail = { fg = c.comment, bg = c.surface }

  local function mode(colour)
    return { a = { fg = c.bg, bg = colour, gui = "bold" }, b = mid, c = tail }
  end

  return {
    normal   = mode(c.keyword),
    insert   = mode(c.ok),
    visual   = mode(c.num),
    replace  = mode(c.err),
    command  = mode(c.info),
    inactive = { a = tail, b = tail, c = tail },
  }
end

return M
