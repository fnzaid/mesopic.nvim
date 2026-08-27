-- mesopic.nvim | config

local M = {}

---@class MesopicOptions
M.defaults = {
  -- "night" | "day" | "auto" (auto follows vim.o.background)
  variant = "auto",

  -- Chroma multiplier, 0.0 to 1.2. Applied in OKLCH, so 0.7 removes about
  -- the same amount of perceived colour from every hue. Diagnostics are
  -- exempt: the colour that means "stop" must not fade with the rest.
  intensity = 1.0,

  -- Lightness push away from the background, 1.0 to 1.5. Cannot go below
  -- 1.0, because that would drop text under the 4.5:1 floor. Add contrast,
  -- never subtract it.
  contrast = 1.0,

  -- Colour marks what needs attention, not what a token is. Strings, types,
  -- numbers and function names lose their chroma; keywords, diagnostics and
  -- git state keep theirs. Lightness is untouched, so nothing becomes
  -- indistinguishable, it just stops competing for your eye.
  focus = false,

  -- Off by default: most terminals have no real monospace italic and slant
  -- the upright glyphs instead, which hurts small text.
  italic_comments = false,

  dim_inactive = false,
  transparent  = false,

  -- Sets vim.g.terminal_color_0..15. This is what makes lazygit match.
  terminal_colors = true,

  -- Per-group overrides, e.g. { Comment = { fg = "#909090" } }.
  -- These bypass the contrast floors. :checkhealth mesopic will not see them.
  overrides = {},
}

M.options = vim.deepcopy(M.defaults)

local function clamp(x, lo, hi)
  return math.max(lo, math.min(hi, x))
end

---@param opts MesopicOptions|nil
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
  M.options.intensity = clamp(M.options.intensity, 0.0, 1.2)
  M.options.contrast  = clamp(M.options.contrast, 1.0, 1.5)
end

---@return "night"|"day"
function M.variant()
  if M.options.variant == "auto" then
    return vim.o.background == "light" and "day" or "night"
  end
  return M.options.variant
end

return M
