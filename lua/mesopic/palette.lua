-- mesopic.nvim | palette
--
-- Source of truth is OKLCH, not hex. Each entry is { L, C, H }:
--   L  perceptual lightness, 0..1
--   C  chroma
--   H  hue angle in degrees
--
-- Hex is derived at load time so that `intensity` and `contrast` actually
-- mean something. Scaling chroma by 0.8 in OKLCH desaturates every hue by
-- about the same perceived amount; doing the same thing in HSL does not.
--
-- Only four hues carry meaning. Everything structural sits near zero chroma:
--
--    75deg  gold    control flow      the thing you scan for
--   145deg  sage    string data       inert text, not code
--   205deg  teal    types             mid-spectrum, see README on blue
--    15deg  rose    numbers, consts   literals
--
-- Diagnostics get their own hues and are deliberately the highest-chroma
-- values in the file, because they must win the competition for attention.

local color = require("mesopic.color")

local M = {}

-- Hue of the near-neutral structural ramp. A trace of chroma keeps the greys
-- from reading as dead flat without registering as a colour.
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
  func    = { 0.880, 0.030, 250 },

  -- The four are separated on L as well as H, on purpose. Two reasons, both
  -- measured rather than felt:
  --
  -- 1. Colour vision has roughly 10x lower spatial resolution than luminance
  --    for red-green, and 20x lower for blue-yellow (Cavanagh 1991). At code
  --    font sizes an equiluminant hue change is a boundary your form vision
  --    can barely resolve. Hue alone is not enough at 13px.
  --
  -- 2. Rose (15deg) and teal (205deg) sit near the red/blue axis. Presented
  --    at equal luminance they trigger chromostereopsis: red appears nearer
  --    than blue, so tokens drift onto different depth planes. Splitting them
  --    on L kills it. This matters more on the night variant, because the
  --    effect grows with pupil size via Stiles-Crawford.
  --
  -- Spread is 0.105 in L. Earlier builds had 0.020, which was a mistake.
  keyword = { 0.820, 0.120,  75 },
  type    = { 0.790, 0.075, 205 },
  str     = { 0.755, 0.095, 145 },
  num     = { 0.715, 0.100,  15 },

  err     = { 0.680, 0.200,  25 },
  warn    = { 0.760, 0.150,  65 },
  ok      = { 0.760, 0.110, 150 },
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
  comment = { 0.545, 0.022, 250 },
  func    = { 0.330, 0.030, 250 },

  -- Same L spread as night, inverted. See the note in the night table.
  keyword = { 0.430, 0.135,  55 },
  type    = { 0.470, 0.090, 225 },
  str     = { 0.498, 0.100, 150 },
  num     = { 0.530, 0.120,  20 },

  err     = { 0.500, 0.200,  25 },
  warn    = { 0.520, 0.140,  60 },
  ok      = { 0.450, 0.110, 150 },
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

-- Roles exempt from the intensity knob. Diagnostics must stay loud even when
-- the rest of the palette is turned down, or the one colour that means "stop"
-- fades into the one that means "string".
local KEEP_CHROMA = { err = true, warn = true }

-- Roles that lose their chroma in `focus` mode. In focus, colour stops
-- describing what a token *is* and marks only what needs your attention:
-- diagnostics, git state, and control flow. Everything settled goes quiet.
-- Lightness is untouched, so the tokens stay distinguishable by brightness.
local FOCUS_DIM = { str = true, type = true, num = true, func = true, info = true, ok = true }
local FOCUS_CHROMA = 0.18

-- Structural roles. Pushing these with `contrast` would make the chrome shout.
M.structural = {
  bg = true, surface = true, overlay = true, border = true,
  cline = true, sel = true,
}

--- Build a hex palette from the OKLCH source.
---@param variant "night"|"day"
---@param opts table|nil { intensity = number, contrast = number }
---@return table<string,string>
function M.build(variant, opts)
  opts = opts or {}
  local intensity = opts.intensity or 1.0   -- chroma multiplier
  local contrast  = opts.contrast  or 1.0   -- lightness push away from bg
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
      -- Push away from the background: brighter on night, darker on day.
      -- Scaling the distance from the extreme means nothing can overshoot.
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

--- Contrast of every text-bearing role against the background.
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

--- Minimum acceptable ratio per role: 4.5 for anything carrying text,
--- 3.0 for structural UI that only needs to be locatable.
M.floors = setmetatable({ gutter = 3.0, br_black = 3.0 }, {
  __index = function() return 4.5 end,
})

return M
