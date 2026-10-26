local M = {}
function M.generate(c)
  return require("mesopic.extra").template([[
# mesopic.nvim ${name} for tmux. Generated file, do not edit.
# Source from tmux.conf:  source-file ~/.config/tmux/${name}.tmux

set -g mode-style "fg=${keyword},bg=${sel}"
set -g message-style "fg=${fg},bg=${surface}"
set -g message-command-style "fg=${fg},bg=${surface}"
set -g pane-border-style "fg=${border}"
set -g pane-active-border-style "fg=${keyword}"
set -g status "on"
set -g status-justify "left"
set -g status-style "fg=${punct},bg=${surface}"
set -g status-left-length "100"
set -g status-right-length "100"
set -g status-left "#[fg=${bg},bg=${keyword},bold] #S #[fg=${keyword},bg=${surface},nobold] "
set -g status-right "#[fg=${comment},bg=${surface}] %Y-%m-%d  %H:%M #[fg=${bg},bg=${keyword},bold] #h "
setw -g window-status-activity-style "underscore,fg=${warn},bg=${surface}"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=${comment},bg=${surface}"
setw -g window-status-format "#[fg=${comment},bg=${surface}] #I #W #F "
setw -g window-status-current-format "#[fg=${fg},bg=${bg},bold] #I #W #F "
]], c)
end
return M
