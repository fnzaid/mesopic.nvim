local M = {}
function M.generate(c)
  return require("mesopic.extra").template([[
{
  "name": "${name}",
  "background": "${bg}",
  "foreground": "${fg}",
  "cursorColor": "${fg}",
  "selectionBackground": "${sel}",
  "black": "${black}",
  "red": "${red}",
  "green": "${green}",
  "yellow": "${yellow}",
  "blue": "${blue}",
  "purple": "${magenta}",
  "cyan": "${cyan}",
  "white": "${white}",
  "brightBlack": "${br_black}",
  "brightRed": "${br_red}",
  "brightGreen": "${br_green}",
  "brightYellow": "${br_yellow}",
  "brightBlue": "${br_blue}",
  "brightPurple": "${br_magenta}",
  "brightCyan": "${br_cyan}",
  "brightWhite": "${br_white}"
}
]], c)
end
return M
