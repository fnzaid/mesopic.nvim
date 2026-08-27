-- mesopic.nvim | colour maths
--
-- The palette is stored as OKLCH triples, not hex. That is what makes the
-- `intensity` and `contrast` knobs meaningful: turning chroma down by 20%
-- in OKLCH lowers the perceived colourfulness of every hue by roughly the
-- same amount, which is not true in HSL. Conversion happens once at load.
--
-- Oklab/OKLCH per Björn Ottosson (2020). It is a pragmatic improvement over
-- CIELAB for this, not lab-validated ground truth, so the ends of any ramp
-- still deserve a look.

local M = {}

local function clamp01(x)
  if x < 0 then return 0 elseif x > 1 then return 1 end
  return x
end

-- linear-light channel -> sRGB encoded channel
local function encode(x)
  if x <= 0.0031308 then
    return 12.92 * x
  end
  return 1.055 * x ^ (1 / 2.4) - 0.055
end

-- sRGB encoded channel -> linear-light channel
local function decode(x)
  if x <= 0.04045 then
    return x / 12.92
  end
  return ((x + 0.055) / 1.055) ^ 2.4
end

--- OKLCH to linear sRGB. Returns three floats, possibly out of [0,1].
local function oklch_to_linear(L, C, H)
  local h = math.rad(H)
  local a = C * math.cos(h)
  local b = C * math.sin(h)

  local l_ = L + 0.3963377774 * a + 0.2158037573 * b
  local m_ = L - 0.1055613458 * a - 0.0638541728 * b
  local s_ = L - 0.0894841775 * a - 1.2914855480 * b

  local l, m, s = l_ * l_ * l_, m_ * m_ * m_, s_ * s_ * s_

  return
     4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
    -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
    -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
end

local function in_gamut(r, g, b)
  local eps = 0.0001
  return r >= -eps and r <= 1 + eps
     and g >= -eps and g <= 1 + eps
     and b >= -eps and b <= 1 + eps
end

--- OKLCH to "#RRGGBB".
--- Out-of-gamut colours have their chroma reduced until they fit, which
--- preserves lightness (and therefore contrast) at the cost of saturation.
--- Clipping RGB directly would do the opposite and silently break contrast.
---@param L number 0..1 perceptual lightness
---@param C number chroma, roughly 0..0.37
---@param H number hue angle in degrees
---@return string hex
function M.oklch_to_hex(L, C, H)
  local r, g, b = oklch_to_linear(L, C, H)

  if not in_gamut(r, g, b) then
    local lo, hi = 0, C
    for _ = 1, 24 do
      local mid = (lo + hi) / 2
      r, g, b = oklch_to_linear(L, mid, H)
      if in_gamut(r, g, b) then lo = mid else hi = mid end
    end
    r, g, b = oklch_to_linear(L, lo, H)
  end

  return string.format("#%02X%02X%02X",
    math.floor(clamp01(encode(r)) * 255 + 0.5),
    math.floor(clamp01(encode(g)) * 255 + 0.5),
    math.floor(clamp01(encode(b)) * 255 + 0.5))
end

--- WCAG relative luminance of a hex colour.
---@param hex string "#RRGGBB"
---@return number
function M.luminance(hex)
  local r = tonumber(hex:sub(2, 3), 16) / 255
  local g = tonumber(hex:sub(4, 5), 16) / 255
  local b = tonumber(hex:sub(6, 7), 16) / 255
  return 0.2126 * decode(r) + 0.7152 * decode(g) + 0.0722 * decode(b)
end

--- WCAG contrast ratio between two hex colours. 1.0 to 21.0.
---@param a string
---@param b string
---@return number
function M.contrast(a, b)
  local la, lb = M.luminance(a), M.luminance(b)
  local hi = math.max(la, lb)
  local lo = math.min(la, lb)
  return (hi + 0.05) / (lo + 0.05)
end

--- Blend two hex colours in linear light. `t` = 0 returns `a`.
--- Linear-light blending is why this does not go muddy in the middle the way
--- naive hex averaging does.
---@param a string
---@param b string
---@param t number 0..1
---@return string
function M.mix(a, b, t)
  local out = "#"
  for i = 2, 6, 2 do
    local ca = decode(tonumber(a:sub(i, i + 1), 16) / 255)
    local cb = decode(tonumber(b:sub(i, i + 1), 16) / 255)
    local c = ca + (cb - ca) * t
    out = out .. string.format("%02X", math.floor(clamp01(encode(c)) * 255 + 0.5))
  end
  return out
end

return M
