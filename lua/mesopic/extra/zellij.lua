local M = {}
function M.generate(c)
  return require("mesopic.extra").template([[
// mesopic.nvim ${name} for Zellij. Generated file, do not edit.
// Save under ~/.config/zellij/themes/ and set theme "${name}" in config.kdl.

themes {
    ${name} {
        fg "${fg}"
        bg "${surface}"
        black "${bg}"
        red "${red}"
        green "${green}"
        yellow "${yellow}"
        blue "${blue}"
        magenta "${magenta}"
        cyan "${cyan}"
        white "${punct}"
        orange "${warn}"
    }
}
]], c)
end
return M
