-- Headless smoke test:  nvim --headless -u tests/init.lua +q
-- Loads both schemes, exercises the API and :checkhealth, and fails on any
-- Lua error or health warning.
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.runtimepath:prepend(root)
vim.o.termguicolors = true

local function step(name, f)
  local ok, err = pcall(f)
  if not ok then
    io.stderr:write(("FAIL %s: %s\n"):format(name, err))
    os.exit(1)
  end
  print("ok   " .. name)
end

local m = require("mesopic")

step("colorscheme mesopic follows dark background", function()
  vim.o.background = "dark"
  vim.cmd.colorscheme("mesopic")
  assert(vim.g.colors_name == "mesopic", vim.g.colors_name)
  assert(m.current.variant == "night", m.current.variant)
  assert(vim.o.background == "dark")
end)

step("set background=light re-sources mesopic as day", function()
  vim.o.background = "light"
  assert(vim.g.colors_name == "mesopic", vim.g.colors_name)
  assert(m.current.variant == "day", m.current.variant)
end)

step("colorscheme photopic pins day", function()
  vim.o.background = "dark"
  vim.cmd.colorscheme("photopic")
  assert(vim.g.colors_name == "photopic")
  assert(m.current.variant == "day")
  assert(vim.o.background == "light")
end)

step("toggle and focus", function()
  m.toggle()
  assert(m.current.variant == "night")
  m.focus(true)
  assert(require("mesopic.config").options.focus == true)
  m.focus(false)
end)

step(":Mesopic command", function()
  vim.cmd.runtime("plugin/mesopic.lua")  -- plugin files load after -u init.lua
  vim.cmd("Mesopic day")
  assert(m.current.variant == "day")
  vim.cmd("Mesopic night")
  assert(m.current.variant == "night")
end)

step("hooks and styles", function()
  m.setup({
    styles = { comments = { italic = true } },
    on_colors = function(c) c.keyword = "#FFFFFF" end,
    on_highlights = function(hl, c) hl.Comment = { fg = c.punct } end,
    overrides = { Title = { fg = "#000000" } },
  })
  vim.cmd.colorscheme("mesopic")
  local kw = vim.api.nvim_get_hl(0, { name = "Keyword" })
  assert(kw.fg == 0xFFFFFF, string.format("%x", kw.fg or 0))
  local cm = vim.api.nvim_get_hl(0, { name = "Comment" })
  assert(cm.fg == tonumber(m.palette().punct:sub(2), 16))
  local ti = vim.api.nvim_get_hl(0, { name = "Title" })
  assert(ti.fg == 0)
  local md = vim.api.nvim_get_hl(0, { name = "@markup.italic" })
  assert(md.italic == true)
  m.setup({})
  vim.cmd.colorscheme("mesopic")
end)

step("every group spec is accepted by nvim_set_hl", function()
  local n = 0
  for _ in pairs(vim.api.nvim_get_hl(0, {})) do n = n + 1 end
  assert(n > 800, "only " .. n .. " groups defined")
end)

step("lualine themes resolve", function()
  for _, name in ipairs({ "mesopic", "photopic" }) do
    local t = require("lualine.themes." .. name)
    assert(t.normal.a.bg and t.inactive.c.fg)
  end
end)

step("checkhealth has no warnings", function()
  vim.cmd("checkhealth mesopic")
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local warnings = {}
  for _, l in ipairs(lines) do
    if l:match("^%- WARNING") or l:match("^%- ERROR") then warnings[#warnings + 1] = l end
  end
  assert(#warnings == 0, table.concat(warnings, "\n"))
end)

step("extras generate and are current", function()
  local extra = require("mesopic.extra")
  local night, day = extra.colors("night"), extra.colors("day")
  for name, target in pairs(extra.targets) do
    local gen = require("mesopic.extra." .. name)
    local outputs = {}
    if target.both then
      outputs[target.path] = gen.generate(night, day)
    else
      outputs[target.path:format("mesopic")] = gen.generate(night)
      outputs[target.path:format("photopic")] = gen.generate(day)
    end
    for rel, text in pairs(outputs) do
      local f = assert(io.open(root .. "/extras/" .. rel, "r"), "missing extras/" .. rel .. " (run nvim -l scripts/build.lua)")
      local on_disk = f:read("*a")
      f:close()
      assert(on_disk == text, "extras/" .. rel .. " is stale (run nvim -l scripts/build.lua)")
    end
  end
end)

print("all tests passed")
