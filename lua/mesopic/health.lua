-- mesopic.nvim | :checkhealth mesopic
--
-- Measures the live palette rather than a table in the README, so your
-- intensity and contrast settings are what actually gets checked.

local palette = require("mesopic.palette")
local config  = require("mesopic.config")

local M = {}

local start = vim.health.start or vim.health.report_start
local ok    = vim.health.ok or vim.health.report_ok
local warn  = vim.health.warn or vim.health.report_warn
local info  = vim.health.info or vim.health.report_info

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
    start("contrast: " .. variant)

    local p = palette.build(variant, o)
    local report = palette.audit(p)

    local roles = {}
    for role in pairs(report) do
      if not role:match("^br_") then roles[#roles + 1] = role end
    end
    table.sort(roles, function(a, b) return report[a] < report[b] end)

    local failures = 0
    for _, role in ipairs(roles) do
      local ratio = report[role]
      local floor = palette.floors[role]
      local line = ("%-9s %s  %5.2f:1  (floor %.1f)"):format(role, p[role], ratio, floor)
      if ratio < floor then
        warn(line)
        failures = failures + 1
      else
        info(line)
      end
    end

    if failures == 0 then
      ok(("all %d roles clear their contrast floor against %s"):format(#roles, p.bg))
    else
      warn(("%d role(s) below floor -- lower `intensity` or raise `contrast`"):format(failures))
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
