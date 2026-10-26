local M = {}
function M.generate(c)
  return require("mesopic.extra").template([[
# mesopic.nvim ${name} for WezTerm. Generated file, do not edit.
# Save under ~/.config/wezterm/colors/ and set color_scheme = "${name}".

[colors]
foreground = "${fg}"
background = "${bg}"
cursor_bg = "${fg}"
cursor_border = "${fg}"
cursor_fg = "${bg}"
selection_bg = "${sel}"
selection_fg = "${fg}"
split = "${border}"
scrollbar_thumb = "${gutter}"

ansi = ["${black}", "${red}", "${green}", "${yellow}", "${blue}", "${magenta}", "${cyan}", "${white}"]
brights = ["${br_black}", "${br_red}", "${br_green}", "${br_yellow}", "${br_blue}", "${br_magenta}", "${br_cyan}", "${br_white}"]

[colors.tab_bar]
background = "${surface}"

[colors.tab_bar.active_tab]
fg_color = "${fg}"
bg_color = "${bg}"

[colors.tab_bar.inactive_tab]
fg_color = "${comment}"
bg_color = "${surface}"

[colors.tab_bar.inactive_tab_hover]
fg_color = "${fg}"
bg_color = "${overlay}"

[colors.tab_bar.new_tab]
fg_color = "${comment}"
bg_color = "${surface}"

[colors.tab_bar.new_tab_hover]
fg_color = "${fg}"
bg_color = "${overlay}"

[metadata]
name = "${name}"
]], c)
end
return M
