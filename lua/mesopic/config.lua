local M = {}

---@class MesopicStyles
---@field comments table
---@field keywords table
---@field functions table
---@field variables table
---@field strings table
---@field types table

---@class MesopicOptions
M.defaults = {
  -- "night" | "day" | "auto". `auto` follows vim.o.background through the
  -- `background` map below.
  variant = "auto",
  background = { dark = "night", light = "day" },

  -- Chroma multiplier, 0.0 to 1.2. Diagnostics are exempt.
  intensity = 1.0,

  -- Lightness push away from the background, 1.0 to 1.5. Never below 1.0,
  -- which would drop text under the 4.5:1 floor.
  contrast = 1.0,

  -- Strip chroma from strings, types, numbers and functions. Keywords,
  -- diagnostics and git state keep theirs. Lightness is untouched.
  focus = false,

  -- Extra attributes per token class, e.g. { comments = { italic = true } }.
  -- Everything is upright by default: most terminal fonts fake italics.
  styles = {
    comments  = {},
    keywords  = {},
    functions = {},
    variables = {},
    strings   = {},
    types     = {},
  },

  dim_inactive = false,
  transparent  = false,

  -- Sets vim.g.terminal_color_0..15.
  terminal_colors = true,

  -- Change palette roles before groups are built: function(c) c.keyword = "#..." end
  on_colors = function(_) end,

  -- Change or add groups with palette access: function(hl, c) hl.Comment = { fg = c.punct } end
  on_highlights = function(_, _) end,

  -- Raw per-group overrides applied last. Not contrast-checked by :checkhealth.
  overrides = {},
}

M.options = vim.deepcopy(M.defaults)

local function clamp(x, lo, hi)
  return math.max(lo, math.min(hi, x))
end

---@param opts MesopicOptions|nil
function M.setup(opts)
  opts = opts or {}
  M.options = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts)
  -- Deprecated alias kept for old configs.
  if opts.italic_comments then
    M.options.styles.comments.italic = true
  end
  M.options.intensity = clamp(M.options.intensity, 0.0, 1.2)
  M.options.contrast  = clamp(M.options.contrast, 1.0, 1.5)
end

---@return "night"|"day"
function M.variant()
  if M.options.variant == "auto" then
    return M.options.background[vim.o.background] or "night"
  end
  return M.options.variant
end

return M
