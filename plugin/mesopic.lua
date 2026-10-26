if vim.g.loaded_mesopic then return end
vim.g.loaded_mesopic = true

local actions = { "night", "day", "toggle", "focus" }

vim.api.nvim_create_user_command("Mesopic", function(cmd)
  local m = require("mesopic")
  local arg = cmd.fargs[1] or "toggle"
  if arg == "toggle" then
    m.toggle()
  elseif arg == "focus" then
    m.focus()
  elseif arg == "night" or arg == "day" then
    m.set(arg)
  else
    vim.notify("Mesopic: unknown argument " .. arg, vim.log.levels.ERROR)
  end
end, {
  nargs = "?",
  complete = function(lead)
    return vim.tbl_filter(function(a) return a:find(lead, 1, true) == 1 end, actions)
  end,
  desc = "mesopic.nvim: night | day | toggle | focus",
})
