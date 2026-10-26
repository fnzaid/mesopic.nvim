local M = {}
function M.generate(c)
  return require("mesopic.extra").template([[
# mesopic.nvim ${name} for fish. Generated file, do not edit.
# Source from config.fish:  source ~/.config/fish/${name}.fish

set -g fish_color_normal ${fg.plain}
set -g fish_color_command ${func.plain}
set -g fish_color_keyword ${keyword.plain}
set -g fish_color_quote ${str.plain}
set -g fish_color_redirection ${num.plain}
set -g fish_color_end ${punct.plain}
set -g fish_color_error ${err.plain}
set -g fish_color_param ${fg.plain}
set -g fish_color_valid_path --underline
set -g fish_color_option ${type.plain}
set -g fish_color_comment ${comment.plain}
set -g fish_color_selection --background=${sel.plain}
set -g fish_color_operator ${punct.plain}
set -g fish_color_escape ${num.plain}
set -g fish_color_autosuggestion ${gutter.plain}
set -g fish_color_cwd ${type.plain}
set -g fish_color_user ${ok.plain}
set -g fish_color_host ${info.plain}
set -g fish_color_host_remote ${warn.plain}
set -g fish_color_cancel ${err.plain}
set -g fish_color_search_match --background=${sel.plain}

set -g fish_pager_color_progress ${comment.plain}
set -g fish_pager_color_prefix ${keyword.plain}
set -g fish_pager_color_completion ${fg.plain}
set -g fish_pager_color_description ${comment.plain}
set -g fish_pager_color_selected_background --background=${sel.plain}
]], c)
end
return M
