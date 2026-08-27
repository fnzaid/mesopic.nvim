-- mesopic.nvim | palette
--
-- Every value was generated in OKLCH and its contrast against the editor
-- background measured, not eyeballed. The ratio in each comment is against
-- `bg` for that variant. Floor is 4.5:1 for anything that carries text,
-- 3:1 for structural UI. If you change a colour, re-measure it.
--
-- Design rule, stated once: chroma is scarce. Identifiers, properties and
-- punctuation stay near-neutral because they are the most common tokens on
-- screen. Colour is spent on the four things you scan for -- control flow,
-- string data, types, and errors -- so each one still means something.

local M = {}

M.night = {
  -- structure
  bg      = "#1B2025",
  surface = "#262B31",
  overlay = "#30363D",
  border  = "#3A4048",
  cline   = "#23282E",
  gutter  = "#70757C", -- 3.53:1  structural, clears the 3:1 UI floor
  sel     = "#333A42",

  -- text
  fg      = "#DADEE3", -- 12.14:1
  punct   = "#9A9FA5", --  6.15:1
  comment = "#858F9A", --  4.99:1  most themes fail this one
  func    = "#C9DAEB", -- 11.49:1  near-neutral on purpose: functions are frequent

  -- the four that carry meaning
  keyword = "#EBB25F", --  8.65:1  control flow
  str     = "#93C794", --  8.47:1  string data
  type    = "#83C8D0", --  8.70:1  types (teal, not blue -- see README)
  num     = "#EBA0A5", --  7.89:1  numbers and constants

  -- diagnostics
  err     = "#FC5855", --  5.21:1
  warn    = "#F19B37", --  7.41:1
  ok      = "#7CC58C", --  7.99:1
  info    = "#80C1E1", --  8.31:1

  -- ansi brights (terminal + lazygit)
  br_black   = "#70757C",
  br_red     = "#FF8E86",
  br_green   = "#A9DEAA",
  br_yellow  = "#FFCA80",
  br_blue    = "#A3DDE4",
  br_magenta = "#FEB9BD",
  br_cyan    = "#ABE0DC",
  br_white   = "#EFF2F5",
}

M.day = {
  bg      = "#F7F5EF", -- warm paper, not #FFFFFF: pure white at full backlight is glare
  surface = "#EEEBE4",
  overlay = "#E4E1D9",
  border  = "#D4D1C8",
  cline   = "#F1EFE8",
  gutter  = "#838078", --  3.62:1
  sel     = "#DEDBD2",

  fg      = "#232A30", -- 13.33:1
  punct   = "#595E64", --  6.00:1
  comment = "#67717D", --  4.55:1
  func    = "#2A3744", -- 11.14:1

  keyword = "#934400", --  6.28:1
  str     = "#236436", --  6.53:1
  type    = "#005F7B", --  6.59:1
  num     = "#933239", --  6.99:1

  err     = "#BB061E", --  6.10:1
  warn    = "#A15000", --  5.26:1
  ok      = "#196632", --  6.45:1
  info    = "#216188", --  6.15:1

  br_black   = "#838078",
  br_red     = "#9B0007",
  br_green   = "#085023",
  br_yellow  = "#793300",
  br_blue    = "#004B66",
  br_magenta = "#782129",
  br_cyan    = "#00525A",
  br_white   = "#11171D",
}

---@param variant "night"|"day"
function M.get(variant)
  return M[variant] or M.night
end

return M
