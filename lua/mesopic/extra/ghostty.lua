local M = {}
function M.generate(c)
  return require("mesopic.extra").template([[
# mesopic.nvim ${name} for Ghostty. Generated file, do not edit.
# Save under ~/.config/ghostty/themes/${name} and set theme = ${name}.

palette = 0=${black}
palette = 1=${red}
palette = 2=${green}
palette = 3=${yellow}
palette = 4=${blue}
palette = 5=${magenta}
palette = 6=${cyan}
palette = 7=${white}
palette = 8=${br_black}
palette = 9=${br_red}
palette = 10=${br_green}
palette = 11=${br_yellow}
palette = 12=${br_blue}
palette = 13=${br_magenta}
palette = 14=${br_cyan}
palette = 15=${br_white}

background = ${bg}
foreground = ${fg}
cursor-color = ${fg}
cursor-text = ${bg}
selection-background = ${sel}
selection-foreground = ${fg}
]], c)
end
return M
