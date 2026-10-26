local M = {}
function M.generate(c)
  return require("mesopic.extra").template([[
# mesopic.nvim ${name} for fzf. Generated file, do not edit.
# Source from your shell rc (bash, zsh):  source ~/.config/fzf/${name}.sh

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --color=fg:${fg},bg:${bg},hl:${keyword} \
  --color=fg+:${fg},bg+:${sel},hl+:${keyword} \
  --color=info:${comment},prompt:${keyword},pointer:${keyword} \
  --color=marker:${ok},spinner:${keyword},header:${comment} \
  --color=border:${border},gutter:${bg},selected-bg:${sel}"
]], c)
end
return M
