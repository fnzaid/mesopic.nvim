-- Contrast gate:  nvim -l scripts/check.lua
-- Audits both variants at default and extreme options, under normal vision
-- and simulated protanopia and deuteranopia. Exits 1 if any role falls
-- under its WCAG floor. APCA Lc is printed for information.
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.runtimepath:prepend(root)

local palette = require("mesopic.palette")
local color   = require("mesopic.color")

local option_sets = {
  { label = "defaults",      intensity = 1.0, contrast = 1.0, focus = false },
  { label = "intensity 1.2", intensity = 1.2, contrast = 1.0, focus = false },
  { label = "intensity 0.0", intensity = 0.0, contrast = 1.0, focus = false },
  { label = "contrast 1.5",  intensity = 1.0, contrast = 1.5, focus = false },
  { label = "focus",         intensity = 1.0, contrast = 1.0, focus = true },
}

local failures = 0

for _, variant in ipairs({ "night", "day" }) do
  for _, opts in ipairs(option_sets) do
    local p = palette.build(variant, opts)
    for _, vision in ipairs({ "normal", "protan", "deutan" }) do
      local sim = function(hex) return vision == "normal" and hex or color.simulate(hex, vision) end
      local bg = sim(p.bg)
      local worst, worst_role = math.huge, nil
      for role, hex in pairs(p) do
        if not palette.structural[role] then
          local ratio = color.contrast(sim(hex), bg)
          if ratio < worst then worst, worst_role = ratio, role end
          if ratio < palette.floors[role] then
            failures = failures + 1
            print(("FAIL %-5s %-14s %-7s %-8s %s %.2f:1 < %.1f  Lc %.0f")
              :format(variant, opts.label, vision, role, hex, ratio, palette.floors[role], color.apca(sim(hex), bg)))
          end
        end
      end
      print(("ok   %-5s %-14s %-7s worst %-8s %.2f:1"):format(variant, opts.label, vision, worst_role, worst))
    end
  end
end

-- Tinted backgrounds must keep their foreground readable.
for _, variant in ipairs({ "night", "day" }) do
  local p = palette.build(variant, { intensity = 1.0, contrast = 1.0 })
  local hl = require("mesopic.highlights").get(p, require("mesopic.config").defaults)
  for _, name in ipairs({ "DiagnosticVirtualTextError", "DiagnosticVirtualTextWarn", "DiagnosticVirtualTextInfo",
                          "DiagnosticVirtualTextHint", "DiagnosticVirtualTextOk", "DiffAdd", "DiffDelete", "DiffChange", "DiffText", "Search" }) do
    local g = hl[name]
    local ratio = color.contrast(g.fg or p.fg, g.bg)
    if ratio < 4.5 then
      failures = failures + 1
      print(("FAIL %-5s group %s fg %s on bg %s %.2f:1"):format(variant, name, g.fg or p.fg, g.bg, ratio))
    end
  end
end

if failures > 0 then
  print(("%d failure(s)"):format(failures))
  os.exit(1)
end
print("all roles clear their floors in every variant, option set and vision type")
