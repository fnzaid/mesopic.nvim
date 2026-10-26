-- Generated extras. Every file under extras/ comes from palette.build() at
-- default options, so they cannot go stale when the palette changes.
--
--   nvim -l scripts/build.lua        regenerate everything

local palette = require("mesopic.palette")
local config  = require("mesopic.config")
local color   = require("mesopic.color")

local M = {}

-- target -> { path pattern (%s = scheme name), both = true for one file carrying both variants }
M.targets = {
  kitty            = { path = "kitty/%s.conf" },
  wezterm          = { path = "wezterm/%s.toml" },
  ghostty          = { path = "ghostty/%s" },
  alacritty        = { path = "alacritty/%s.toml" },
  foot             = { path = "foot/%s.ini" },
  windows_terminal = { path = "windows_terminal/%s.json" },
  xresources       = { path = "xresources/%s.Xresources" },
  tmux             = { path = "tmux/%s.tmux" },
  zellij           = { path = "zellij/%s.kdl" },
  fish             = { path = "fish/%s.fish" },
  fzf              = { path = "fzf/%s.sh" },
  delta            = { path = "delta/%s.gitconfig" },
  starship         = { path = "starship/%s.toml" },
  lazygit          = { path = "lazygit/mesopic.yml", both = true },
}

--- Palette plus the derived values templates need.
---@param variant "night"|"day"
function M.colors(variant)
  local c = palette.build(variant, config.defaults)
  c.name    = (variant == "day") and "photopic" or "mesopic"
  c.variant = variant
  c.black, c.red, c.green, c.yellow = c.surface, c.err, c.ok, c.keyword
  c.blue, c.magenta, c.cyan, c.white = c.info, c.num, c.type, c.fg
  c.add      = color.mix(c.bg, c.ok,  0.15)
  c.add_emph = color.mix(c.bg, c.ok,  0.30)
  c.del      = color.mix(c.bg, c.err, 0.15)
  c.del_emph = color.mix(c.bg, c.err, 0.30)
  return c
end

--- Replace ${key} with values[key]; ${key.plain} strips the leading '#'.
---@param str string
---@param values table<string,string>
---@return string
function M.template(str, values)
  return (str:gsub("%${([%w_]+)%.?(%w*)}", function(key, mod)
    local v = values[key]
    if v == nil then error("extra template: unknown key " .. key) end
    if mod == "plain" then v = v:gsub("^#", "") end
    return v
  end))
end

--- Generate every target into `root`/extras.
---@param root string repository root
---@return string[] written paths
function M.generate_all(root)
  local written = {}
  local night, day = M.colors("night"), M.colors("day")
  for name, target in pairs(M.targets) do
    local gen = require("mesopic.extra." .. name)
    local outputs = {}
    if target.both then
      outputs[target.path] = gen.generate(night, day)
    else
      for _, c in ipairs({ night, day }) do
        outputs[target.path:format(c.name)] = gen.generate(c)
      end
    end
    for rel, text in pairs(outputs) do
      local path = root .. "/extras/" .. rel
      vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
      local f = assert(io.open(path, "w"))
      f:write(text)
      f:close()
      written[#written + 1] = path
    end
  end
  table.sort(written)
  return written
end

return M
