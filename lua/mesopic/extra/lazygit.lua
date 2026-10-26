local M = {}

local function block(c, indent)
  local pad = string.rep(" ", indent)
  local lines = {
    "activeBorderColor:", "  - \"${keyword}\"", "  - bold",
    "inactiveBorderColor:", "  - \"${border}\"",
    "searchingActiveBorderColor:", "  - \"${warn}\"", "  - bold",
    "optionsTextColor:", "  - \"${info}\"",
    "selectedLineBgColor:", "  - \"${sel}\"",
    "selectedLineFgColor:", "  - default",
    "inactiveViewSelectedLineBgColor:", "  - \"${cline}\"",
    "cherryPickedCommitBgColor:", "  - \"${sel}\"",
    "cherryPickedCommitFgColor:", "  - \"${keyword}\"",
    "markedBaseCommitBgColor:", "  - \"${sel}\"",
    "markedBaseCommitFgColor:", "  - \"${info}\"",
    "unstagedChangesColor:", "  - \"${err}\"",
    "defaultFgColor:", "  - \"${fg}\"",
    "authorColors:", "  \"*\": \"${punct}\"",
  }
  for i, l in ipairs(lines) do lines[i] = pad .. l end
  return require("mesopic.extra").template(table.concat(lines, "\n"), c)
end

--- One file for both variants: darkTheme and lightTheme follow the
--- terminal background. Inside Neovim lazygit already matches through
--- terminal_colors; this is for lazygit in a shell.
function M.generate(night, day)
  return table.concat({
    "# mesopic.nvim for lazygit. Generated file, do not edit.",
    "# Merge into ~/.config/lazygit/config.yml. darkTheme and lightTheme are",
    "# picked from the terminal background. authorColors is deliberately one",
    "# colour: author names are metadata, not signal.",
    "",
    "gui:",
    "  theme:",
    block(night, 4),
    "  darkTheme:",
    block(night, 4),
    "  lightTheme:",
    block(day, 4),
    "",
  }, "\n")
end

return M
