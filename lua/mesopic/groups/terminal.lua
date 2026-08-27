-- mesopic.nvim | terminal colours
--
-- This is the file that makes lazygit match, and it is the piece most themes
-- skip. lazygit does not read your colorscheme. When it runs inside :terminal
-- it renders with the 16 ANSI colours Neovim exposes as vim.g.terminal_color_0
-- through _15. Set those and lazygit, gitui, fzf, htop and anything else in a
-- terminal buffer inherit the palette for free.
--
-- For lazygit running OUTSIDE Neovim, see extras/lazygit.yml.

local M = {}

---@param c table palette
function M.setup(c)
  -- normal
  vim.g.terminal_color_0 = c.surface   -- black
  vim.g.terminal_color_1 = c.err       -- red
  vim.g.terminal_color_2 = c.ok        -- green
  vim.g.terminal_color_3 = c.keyword   -- yellow
  vim.g.terminal_color_4 = c.info      -- blue
  vim.g.terminal_color_5 = c.num       -- magenta
  vim.g.terminal_color_6 = c.type      -- cyan
  vim.g.terminal_color_7 = c.fg        -- white

  -- bright
  vim.g.terminal_color_8  = c.br_black
  vim.g.terminal_color_9  = c.br_red
  vim.g.terminal_color_10 = c.br_green
  vim.g.terminal_color_11 = c.br_yellow
  vim.g.terminal_color_12 = c.br_blue
  vim.g.terminal_color_13 = c.br_magenta
  vim.g.terminal_color_14 = c.br_cyan
  vim.g.terminal_color_15 = c.br_white
end

return M
