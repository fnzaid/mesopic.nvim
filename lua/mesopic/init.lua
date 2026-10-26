-- mesopic.nvim
--   :colorscheme mesopic     follows 'background' (night when dark, day when light)
--   :colorscheme photopic    day, pinned
--   :Mesopic night|day|toggle|focus
--   :checkhealth mesopic     contrast report for the live palette

local config     = require("mesopic.config")
local palette    = require("mesopic.palette")
local highlights = require("mesopic.highlights")
local plugins    = require("mesopic.groups.plugins")
local terminal   = require("mesopic.groups.terminal")

local M = {}

---@type { variant: "night"|"day", name: string }|nil
M.current = nil

---@param opts MesopicOptions|nil
function M.setup(opts)
  config.setup(opts)
end

--- Apply the theme. Does not fire ColorScheme: `:colorscheme` does that.
---@param variant "night"|"day"|nil defaults to the configured variant
---@param name string|nil value for g:colors_name, defaults to the variant's scheme name
function M.load(variant, name)
  local o = config.options
  local v = variant or config.variant()
  name = name or (v == "day" and "photopic" or "mesopic")

  if vim.g.colors_name then
    vim.cmd("highlight clear")
  end
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true

  -- With g:colors_name unset, changing 'background' does not re-source a
  -- colorscheme, so this cannot recurse.
  vim.g.colors_name = nil
  local want = (v == "day") and "light" or "dark"
  if vim.o.background ~= want then
    vim.o.background = want
  end

  local c = palette.build(v, o)
  o.on_colors(c)

  local groups = vim.tbl_extend("force", highlights.get(c, o), plugins.get(c, o))
  o.on_highlights(groups, c)
  groups = vim.tbl_extend("force", groups, o.overrides)

  for group, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  if o.terminal_colors then
    terminal.setup(c)
  end

  vim.g.colors_name = name
  M.current = { variant = v, name = name }
end

local function reload(variant)
  M.load(variant, (variant == "day") and "photopic" or "mesopic")
  vim.api.nvim_exec_autocmds("ColorScheme", { pattern = vim.g.colors_name })
end

--- Load a variant and fire ColorScheme.
---@param variant "night"|"day"
function M.set(variant)
  reload(variant)
end

--- Swap night and day.
function M.toggle()
  local v = M.current and M.current.variant or config.variant()
  reload(v == "day" and "night" or "day")
end

--- Toggle focus mode. See `focus` in config.lua.
---@param on boolean|nil toggles when omitted
function M.focus(on)
  if on == nil then on = not config.options.focus end
  config.options.focus = on
  reload(M.current and M.current.variant or config.variant())
end

--- Built palette for a variant, e.g. for a custom statusline.
---@param variant "night"|"day"|nil
---@return table<string,string>
function M.palette(variant)
  local c = palette.build(variant or config.variant(), config.options)
  config.options.on_colors(c)
  return c
end

--- WCAG contrast of every role against the background.
---@param variant "night"|"day"|nil
---@return table<string,number>
function M.audit(variant)
  return palette.audit(M.palette(variant))
end

--- lualine theme. Also available as theme = "mesopic" or "photopic".
---@param variant "night"|"day"|nil
function M.lualine(variant)
  local c = M.palette(variant)
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
    terminal = mode(c.type),
    inactive = { a = tail, b = tail, c = tail },
  }
end

return M
