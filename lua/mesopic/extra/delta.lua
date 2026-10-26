local M = {}
function M.generate(c)
  local dark = (c.variant == "night") and "true" or "false"
  return require("mesopic.extra").template([[
# mesopic.nvim ${name} for delta. Generated file, do not edit.
# Include from ~/.gitconfig:
#   [include]
#       path = ~/.config/delta/${name}.gitconfig
#   [delta]
#       features = ${name}

[delta "${name}"]
    dark = ]] .. dark .. [[

    line-numbers = true
    minus-style = syntax "${del}"
    minus-emph-style = syntax "${del_emph}"
    plus-style = syntax "${add}"
    plus-emph-style = syntax "${add_emph}"
    zero-style = syntax
    line-numbers-minus-style = "${err}"
    line-numbers-plus-style = "${ok}"
    line-numbers-zero-style = "${gutter}"
    line-numbers-left-style = "${border}"
    line-numbers-right-style = "${border}"
    file-style = "${keyword}" bold
    file-decoration-style = "${border}" ul
    hunk-header-style = file line-number syntax
    hunk-header-decoration-style = "${border}" box
    commit-decoration-style = "${keyword}" box ul
    whitespace-error-style = "${bg}" "${err}"
]], c)
end
return M
