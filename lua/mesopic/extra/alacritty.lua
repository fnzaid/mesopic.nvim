local M = {}
function M.generate(c)
  return require("mesopic.extra").template([[
# mesopic.nvim ${name} for Alacritty. Generated file, do not edit.
# Import from alacritty.toml:  import = ["~/.config/alacritty/${name}.toml"]

[colors.primary]
background = "${bg}"
foreground = "${fg}"

[colors.cursor]
cursor = "${fg}"
text = "${bg}"

[colors.selection]
background = "${sel}"
text = "${fg}"

[colors.search.matches]
background = "${sel}"
foreground = "${keyword}"

[colors.search.focused_match]
background = "${warn}"
foreground = "${bg}"

[colors.normal]
black = "${black}"
red = "${red}"
green = "${green}"
yellow = "${yellow}"
blue = "${blue}"
magenta = "${magenta}"
cyan = "${cyan}"
white = "${white}"

[colors.bright]
black = "${br_black}"
red = "${br_red}"
green = "${br_green}"
yellow = "${br_yellow}"
blue = "${br_blue}"
magenta = "${br_magenta}"
cyan = "${br_cyan}"
white = "${br_white}"
]], c)
end
return M
