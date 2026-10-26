-- Regenerate extras/ from the palette:  nvim -l scripts/build.lua
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.runtimepath:prepend(root)
local written = require("mesopic.extra").generate_all(root)
for _, p in ipairs(written) do
  print("wrote " .. p:sub(#root + 2))
end
