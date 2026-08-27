-- mesopic.nvim
--
--   :colorscheme mesopic     -- night
--   :colorscheme photopic    -- day
--
-- A theme built backwards from how the eye resolves small text. Every colour
-- generated in OKLCH and contrast-measured. README separates what is evidence
-- from what is judgement, including the research that argues against dark mode.

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
  vim.o.background = (v == "day") and "light" or "dark"
  vim.g.colors_name = (v == "day") and "photopic" or "mesopic"

  local c = palette.get(v)
  local o = config.options

  local groups = vim.tbl_extend("force",
    highlights.get(c, o),
    plugins.get(c, o),
    o.overrides
  )

  local set = vim.api.nvim_set_hl
  for group, spec in pairs(groups) do
    set(0, group, spec)
  end

  if o.terminal_colors then
    terminal.setup(c)
  end
end

--- Toggle between night and day without restarting.
function M.toggle()
  M.load(vim.g.colors_name == "photopic" and "night" or "day")
end

--- Expose the raw palette, e.g. for a custom statusline.
---@param variant "night"|"day"|nil
function M.palette(variant)
  return palette.get(variant or config.variant())
end

--- lualine theme. Usage:
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
