local M = {}
function M.generate(c)
  return require("mesopic.extra").template([[
# mesopic.nvim ${name} for foot. Generated file, do not edit.
# Include from foot.ini:  include=~/.config/foot/${name}.ini

[cursor]
color=${bg.plain} ${fg.plain}

[colors]
background=${bg.plain}
foreground=${fg.plain}
selection-background=${sel.plain}
selection-foreground=${fg.plain}
urls=${info.plain}

regular0=${black.plain}
regular1=${red.plain}
regular2=${green.plain}
regular3=${yellow.plain}
regular4=${blue.plain}
regular5=${magenta.plain}
regular6=${cyan.plain}
regular7=${white.plain}

bright0=${br_black.plain}
bright1=${br_red.plain}
bright2=${br_green.plain}
bright3=${br_yellow.plain}
bright4=${br_blue.plain}
bright5=${br_magenta.plain}
bright6=${br_cyan.plain}
bright7=${br_white.plain}
]], c)
end
return M
