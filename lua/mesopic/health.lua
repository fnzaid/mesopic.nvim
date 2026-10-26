-- :checkhealth mesopic. Measures the live palette with the user's options,
-- with normal vision and with simulated protanopia and deuteranopia.

local palette = require("mesopic.palette")
local config  = require("mesopic.config")
local color   = require("mesopic.color")

local M = {}

local start = vim.health.start or vim.health.report_start
local ok    = vim.health.ok or vim.health.report_ok
local warn  = vim.health.warn or vim.health.report_warn
local info  = vim.health.info or vim.health.report_info

local function sorted_roles(report)
  local roles = {}
  for role in pairs(report) do
    if not role:match("^br_") then roles[#roles + 1] = role end
  end
  table.sort(roles, function(a, b) return report[a] < report[b] end)
  return roles
end

--- Audit one palette under one kind of vision. Returns the failure count.
local function audit(p, vision)
  local sim = function(hex)
    return vision == "normal" and hex or color.simulate(hex, vision)
  end
  local bg = sim(p.bg)

  local report = {}
  for role, hex in pairs(p) do
    if not palette.structural[role] then
      report[role] = color.contrast(sim(hex), bg)
    end
  end

  local failures = 0
  for _, role in ipairs(sorted_roles(report)) do
    local ratio = report[role]
    local floor = palette.floors[role]
    local lc    = color.apca(sim(p[role]), bg)
    local line  = ("%-8s %s  %5.2f:1  Lc %3.0f  (floor %.1f:1, Lc %d)")
      :format(role, p[role], ratio, lc, floor, palette.apca_floors[role])
    if ratio < floor then
      warn(line)
      failures = failures + 1
    elseif vision == "normal" then
      info(line)
    end
  end
  return failures
end

function M.check()
  start("mesopic.nvim")

  if not vim.o.termguicolors then
    warn("termguicolors is off; the palette will be approximated to 256 colours",
      { "set vim.o.termguicolors = true" })
  else
    ok("termguicolors enabled")
  end

  local o = config.options
  info(("variant=%s  intensity=%.2f  contrast=%.2f  focus=%s")
    :format(config.variant(), o.intensity, o.contrast, tostring(o.focus)))

  for _, variant in ipairs({ "night", "day" }) do
    local p = palette.build(variant, o)
    o.on_colors(p)

    start("contrast: " .. variant)
    local failures = audit(p, "normal")
    if failures == 0 then
      ok(("all roles clear their WCAG floor against %s"):format(p.bg))
    else
      warn(("%d role(s) below floor -- lower `intensity` or raise `contrast`"):format(failures))
    end

    for _, vision in ipairs({ "protan", "deutan" }) do
      start(("contrast: %s, simulated %s"):format(variant, vision))
      failures = audit(p, vision)
      if failures == 0 then
        ok("all roles clear their floor under simulated " .. vision .. " vision")
      else
        warn(("%d role(s) below floor under simulated %s vision"):format(failures, vision))
      end
    end
  end

  if next(o.overrides) then
    start("overrides")
    local n = 0
    for _ in pairs(o.overrides) do n = n + 1 end
    warn(("%d highlight override(s) set; these are not contrast-checked"):format(n))
  end
end

return M
