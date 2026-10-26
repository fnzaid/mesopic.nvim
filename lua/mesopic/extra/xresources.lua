local M = {}
function M.generate(c)
  return require("mesopic.extra").template([[
! mesopic.nvim ${name} Xresources. Generated file, do not edit.

*.background:  ${bg}
*.foreground:  ${fg}
*.cursorColor: ${fg}

*.color0:  ${black}
*.color1:  ${red}
*.color2:  ${green}
*.color3:  ${yellow}
*.color4:  ${blue}
*.color5:  ${magenta}
*.color6:  ${cyan}
*.color7:  ${white}
*.color8:  ${br_black}
*.color9:  ${br_red}
*.color10: ${br_green}
*.color11: ${br_yellow}
*.color12: ${br_blue}
*.color13: ${br_magenta}
*.color14: ${br_cyan}
*.color15: ${br_white}
]], c)
end
return M
