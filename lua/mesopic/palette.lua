-- Source of truth is OKLCH { L, C, H }; hex is derived at load so that
-- `intensity` and `contrast` scale perceptually.
--
-- Four hues carry meaning, everything structural is near-neutral:
--    75deg  gold    keywords
--   145deg  sage    strings
--   205deg  teal    types
--    15deg  rose    numbers, constants
-- Diagnostics have their own hues and the highest chroma in the file.
--
-- Roles that share a hue family are staggered in L by at least 0.06 so they
-- stay apart when hue collapses under protanopia or deuteranopia. The
-- health check verifies this with simulated vision.

local color = require("mesopic.color")

local M = {}

local NEUTRAL_N = 255
local NEUTRAL_D = 90

M.raw = {}

M.raw.night = {
  bg      = { 0.240, 0.012, NEUTRAL_N },
  surface = { 0.285, 0.014, NEUTRAL_N },
  overlay = { 0.330, 0.015, NEUTRAL_N },
  border  = { 0.370, 0.016, NEUTRAL_N },
  cline   = { 0.275, 0.013, NEUTRAL_N },
  sel     = { 0.320, 0.016, NEUTRAL_N },
  gutter  = { 0.560, 0.012, NEUTRAL_N },

  fg      = { 0.900, 0.008, 250 },
  punct   = { 0.700, 0.010, 250 },
  comment = { 0.645, 0.020, 250 },
  doc     = { 0.680, 0.040, 250 },
  func    = { 0.880, 0.030, 250 },

  keyword = { 0.840, 0.120,  75 },
  type    = { 0.790, 0.075, 205 },
  str     = { 0.770, 0.095, 145 },
  num     = { 0.700, 0.100,  15 },

  err     = { 0.720, 0.190,  25 },
  warn    = { 0.770, 0.150,  65 },
  ok      = { 0.820, 0.110, 150 },
  info    = { 0.780, 0.080, 230 },

  br_black   = { 0.560, 0.012, NEUTRAL_N },
  br_red     = { 0.780, 0.150,  25 },
  br_green   = { 0.850, 0.090, 145 },
  br_yellow  = { 0.870, 0.110,  75 },
  br_blue    = { 0.860, 0.060, 205 },
  br_magenta = { 0.850, 0.080,  15 },
  br_cyan    = { 0.870, 0.055, 190 },
  br_white   = { 0.960, 0.005, 250 },
}

M.raw.day = {
  bg      = { 0.970, 0.008, NEUTRAL_D },
  surface = { 0.940, 0.010, NEUTRAL_D },
  overlay = { 0.910, 0.011, NEUTRAL_D },
  border  = { 0.860, 0.012, NEUTRAL_D },
  cline   = { 0.952, 0.009, NEUTRAL_D },
  sel     = { 0.890, 0.014, NEUTRAL_D },
  gutter  = { 0.600, 0.012, NEUTRAL_D },

  fg      = { 0.280, 0.015, 250 },
  punct   = { 0.480, 0.012, 250 },
  comment = { 0.535, 0.022, 250 },
  doc     = { 0.500, 0.040, 250 },
  func    = { 0.330, 0.030, 250 },

  keyword = { 0.400, 0.135,  55 },
  type    = { 0.470, 0.090, 225 },
  str     = { 0.480, 0.100, 150 },
  num     = { 0.530, 0.120,  20 },

  err     = { 0.460, 0.200,  25 },
  warn    = { 0.520, 0.140,  60 },
  ok      = { 0.400, 0.110, 150 },
  info    = { 0.470, 0.090, 240 },

  br_black   = { 0.600, 0.012, NEUTRAL_D },
  br_red     = { 0.420, 0.190,  25 },
  br_green   = { 0.380, 0.100, 150 },
  br_yellow  = { 0.410, 0.120,  55 },
  br_blue    = { 0.380, 0.090, 225 },
  br_magenta = { 0.390, 0.120,  20 },
  br_cyan    = { 0.400, 0.070, 205 },
  br_white   = { 0.200, 0.015, 250 },
}

-- Exempt from `intensity`: the colour that means "stop" must not fade.
local KEEP_CHROMA = { err = true, warn = true }

-- Lose most of their chroma in `focus` mode.
local FOCUS_DIM = { str = true, type = true, num = true, func = true, info = true, ok = true, doc = true }
local FOCUS_CHROMA = 0.18

-- Not pushed by `contrast`, not audited as text.
M.structural = {
  bg = true, surface = true, overlay = true, border = true,
  cline = true, sel = true,
}

--- Build a hex palette from the OKLCH source.
---@param variant "night"|"day"
---@param opts table|nil { intensity = number, contrast = number, focus = boolean }
---@return table<string,string>
function M.build(variant, opts)
  opts = opts or {}
  local intensity = opts.intensity or 1.0
  local contrast  = opts.contrast  or 1.0
  local focus     = opts.focus or false
  local src  = M.raw[variant] or M.raw.night
  local dark = variant ~= "day"

  local out = {}
  for role, lch in pairs(src) do
    local L, C, H = lch[1], lch[2], lch[3]

    if not KEEP_CHROMA[role] then
      C = C * intensity
      if focus and FOCUS_DIM[role] then
        C = C * FOCUS_CHROMA
      end
    end

    if contrast ~= 1.0 and not M.structural[role] then
      -- Scale the distance from the extreme so nothing can overshoot.
      if dark then
        L = 1 - (1 - L) / contrast
      else
        L = L / contrast
      end
    end

    out[role] = color.oklch_to_hex(L, C, H)
  end

  return out
end

--- WCAG contrast of every text-bearing role against the background.
---@param p table<string,string> built palette
---@return table<string, number>
function M.audit(p)
  local report = {}
  for role, hex in pairs(p) do
    if not M.structural[role] then
      report[role] = color.contrast(hex, p.bg)
    end
  end
  return report
end

--- Minimum WCAG ratio per role: 4.5 for text, 3.0 for UI that only needs locating.
M.floors = setmetatable({ gutter = 3.0, br_black = 3.0 }, {
  __index = function() return 4.5 end,
})

--- Minimum APCA Lc per role. 75 is body text, 60 secondary text, 45 large or
--- bold text. Advisory: WCAG floors above are the hard gate.
M.apca_floors = setmetatable({ gutter = 45, br_black = 45, comment = 60, doc = 60 }, {
  __index = function() return 75 end,
})

return M
