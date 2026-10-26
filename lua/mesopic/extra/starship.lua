local M = {}
function M.generate(c)
  return require("mesopic.extra").template([[
# mesopic.nvim ${name} palette for starship. Generated file, do not edit.
# Append to starship.toml and set:  palette = "${name}"

[palettes.${name}]
bg = "${bg}"
surface = "${surface}"
border = "${border}"
fg = "${fg}"
punct = "${punct}"
comment = "${comment}"
keyword = "${keyword}"
string = "${str}"
type = "${type}"
number = "${num}"
error = "${err}"
warning = "${warn}"
success = "${ok}"
info = "${info}"
]], c)
end
return M
