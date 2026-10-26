local M = {}
function M.generate(c)
  return require("mesopic.extra").template([[
# mesopic.nvim ${name} for kitty. Generated file, do not edit.
# include it from kitty.conf:  include ${name}.conf

background            ${bg}
foreground            ${fg}
selection_background  ${sel}
selection_foreground  ${fg}
cursor                ${fg}
cursor_text_color     ${bg}
url_color             ${info}

active_border_color   ${keyword}
inactive_border_color ${border}
bell_border_color     ${warn}

tab_bar_background      ${surface}
active_tab_background   ${bg}
active_tab_foreground   ${fg}
inactive_tab_background ${surface}
inactive_tab_foreground ${comment}

color0  ${black}
color1  ${red}
color2  ${green}
color3  ${yellow}
color4  ${blue}
color5  ${magenta}
color6  ${cyan}
color7  ${white}
color8  ${br_black}
color9  ${br_red}
color10 ${br_green}
color11 ${br_yellow}
color12 ${br_blue}
color13 ${br_magenta}
color14 ${br_cyan}
color15 ${br_white}
]], c)
end
return M
