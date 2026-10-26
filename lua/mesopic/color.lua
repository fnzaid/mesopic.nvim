-- OKLCH (Ottosson 2020) to sRGB, WCAG and APCA contrast, and dichromacy
-- simulation (Machado, Oliveira and Fernandes 2009, severity 1.0).

local M = {}

local function clamp01(x)
  if x < 0 then return 0 elseif x > 1 then return 1 end
  return x
end

local function encode(x)
  if x <= 0.0031308 then
    return 12.92 * x
  end
  return 1.055 * x ^ (1 / 2.4) - 0.055
end

local function decode(x)
  if x <= 0.04045 then
    return x / 12.92
  end
  return ((x + 0.055) / 1.055) ^ 2.4
end

local function hex_to_linear(hex)
  return decode(tonumber(hex:sub(2, 3), 16) / 255),
         decode(tonumber(hex:sub(4, 5), 16) / 255),
         decode(tonumber(hex:sub(6, 7), 16) / 255)
end

local function linear_to_hex(r, g, b)
  return string.format("#%02X%02X%02X",
    math.floor(clamp01(encode(r)) * 255 + 0.5),
    math.floor(clamp01(encode(g)) * 255 + 0.5),
    math.floor(clamp01(encode(b)) * 255 + 0.5))
end

--- OKLCH to linear sRGB. Channels may fall outside [0,1].
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

--- OKLCH to "#RRGGBB". Out-of-gamut colours have chroma reduced until they
--- fit, which keeps lightness (and therefore contrast) intact.
---@param L number 0..1
---@param C number roughly 0..0.37
---@param H number degrees
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

  return linear_to_hex(r, g, b)
end

--- WCAG relative luminance.
---@param hex string "#RRGGBB"
---@return number
function M.luminance(hex)
  local r, g, b = hex_to_linear(hex)
  return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

--- WCAG contrast ratio, 1.0 to 21.0.
---@param a string
---@param b string
---@return number
function M.contrast(a, b)
  local la, lb = M.luminance(a), M.luminance(b)
  local hi = math.max(la, lb)
  local lo = math.min(la, lb)
  return (hi + 0.05) / (lo + 0.05)
end

local function apca_y(hex)
  local function ch(i)
    return (tonumber(hex:sub(i, i + 1), 16) / 255) ^ 2.4
  end
  local y = 0.2126729 * ch(2) + 0.7151522 * ch(4) + 0.0721750 * ch(6)
  if y < 0.022 then
    y = y + (0.022 - y) ^ 1.414
  end
  return y
end

--- APCA-W3 0.1.9 lightness contrast, as a positive Lc value. 75 is the
--- minimum for body text, 60 for secondary text, 45 for large or bold text.
---@param fg string
---@param bg string
---@return number
function M.apca(fg, bg)
  local yt, yb = apca_y(fg), apca_y(bg)
  if math.abs(yb - yt) < 0.0005 then
    return 0
  end
  local sapc
  if yb > yt then
    sapc = (yb ^ 0.56 - yt ^ 0.57) * 1.14
    if sapc < 0.1 then return 0 end
    return (sapc - 0.027) * 100
  end
  sapc = (yb ^ 0.65 - yt ^ 0.62) * 1.14
  if sapc > -0.1 then return 0 end
  return -(sapc + 0.027) * 100
end

--- Blend two hex colours in linear light. `t` = 0 returns `a`.
---@param a string
---@param b string
---@param t number 0..1
---@return string
function M.mix(a, b, t)
  local ar, ag, ab = hex_to_linear(a)
  local br, bg, bb = hex_to_linear(b)
  return linear_to_hex(ar + (br - ar) * t, ag + (bg - ag) * t, ab + (bb - ab) * t)
end

-- Machado 2009 matrices for full dichromacy, applied in linear sRGB.
local CVD = {
  protan = {
    {  0.152286, 1.052583, -0.204868 },
    {  0.114503, 0.786281,  0.099216 },
    { -0.003882, -0.048116, 1.051998 },
  },
  deutan = {
    {  0.367322, 0.860646, -0.227968 },
    {  0.280085, 0.672501,  0.047413 },
    { -0.011820, 0.042940,  0.968881 },
  },
}

--- A hex colour as a protanope or deuteranope would see it.
---@param hex string
---@param kind "protan"|"deutan"
---@return string
function M.simulate(hex, kind)
  local m = CVD[kind]
  if not m then return hex end
  local r, g, b = hex_to_linear(hex)
  return linear_to_hex(
    m[1][1] * r + m[1][2] * g + m[1][3] * b,
    m[2][1] * r + m[2][2] * g + m[2][3] * b,
    m[3][1] * r + m[3][2] * g + m[3][3] * b)
end

return M
