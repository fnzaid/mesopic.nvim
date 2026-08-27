-- mesopic.nvim | config

local M = {}

---@class MesopicOptions
M.defaults = {
  -- "night" | "day" | "auto" ("auto" follows vim.o.background)
  variant = "auto",

  -- comments in italic. off by default: many terminals fake italics by
  -- slanting the bitmap, which makes small text worse rather than better.
  italic_comments = false,

  -- dim inactive splits so the focused window is obvious
  dim_inactive = false,

  -- transparent background (uses your terminal's own bg)
  transparent = false,

  -- set vim.g.terminal_color_0..15. this is what makes lazygit, gitui and
  -- anything else running in :terminal match the theme. leave it on.
  terminal_colors = true,

  -- per-group overrides, e.g. { Comment = { fg = "#999999" } }
  overrides = {},
}

M.options = vim.deepcopy(M.defaults)

---@param opts MesopicOptions|nil
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

---@return "night"|"day"
function M.variant()
  if M.options.variant == "auto" then
    return vim.o.background == "light" and "day" or "night"
  end
  return M.options.variant
end

return M
