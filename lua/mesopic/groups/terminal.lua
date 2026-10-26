-- vim.g.terminal_color_0..15. Anything in :terminal (lazygit, fzf, htop)
-- renders with these. For lazygit outside Neovim see extras/lazygit.yml.

local M = {}

---@param c table palette
function M.setup(c)
  vim.g.terminal_color_0 = c.surface
  vim.g.terminal_color_1 = c.err
  vim.g.terminal_color_2 = c.ok
  vim.g.terminal_color_3 = c.keyword
  vim.g.terminal_color_4 = c.info
  vim.g.terminal_color_5 = c.num
  vim.g.terminal_color_6 = c.type
  vim.g.terminal_color_7 = c.fg

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
