# mesopic.nvim

Two colour schemes for Neovim.

- `mesopic` is dark. Use it at night.
- `photopic` is light. Use it in the day.

Only four colours have a meaning. All other text is grey.

| colour | meaning |
|---|---|
| gold | keywords |
| green | strings |
| teal | types |
| rose | numbers and constants |

Errors and warnings have their own colours. They are the strongest colours
in the theme.

Each colour is tested for contrast against the background. The test runs
with normal vision and with simulated red-green colour blindness. Run
`:checkhealth mesopic` to see the numbers on your machine.

## Install

With lazy.nvim:

```lua
{
  "HttoZaid/mesopic.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("mesopic").setup({})
    vim.cmd.colorscheme("mesopic")
  end,
}
```

With packer:

```lua
use({
  "HttoZaid/mesopic.nvim",
  config = function()
    require("mesopic").setup({})
    vim.cmd.colorscheme("mesopic")
  end,
})
```

Without a plugin manager, clone the repository into
`~/.config/nvim/pack/themes/start/`.

## Use

```vim
:colorscheme mesopic     " follows 'background': dark = night, light = day
:colorscheme photopic    " light, always
:Mesopic toggle          " swap night and day
:Mesopic focus           " focus mode on or off
:checkhealth mesopic     " contrast report
:help mesopic            " full documentation
```

`mesopic` follows `background`. When you run `:set background=light`, the
day palette loads. `photopic` always loads the day palette.

## Options

These are the default values.

```lua
require("mesopic").setup({
  variant         = "auto",  -- "night", "day", or "auto"
  background      = { dark = "night", light = "day" },
  intensity       = 1.0,     -- 0.0 to 1.2. Less is more grey.
  contrast        = 1.0,     -- 1.0 to 1.5. More is brighter text.
  focus           = false,   -- true removes colour from most code
  styles = {                 -- extra attributes per token class
    comments  = {},          -- e.g. { italic = true }
    keywords  = {},
    functions = {},
    variables = {},
    strings   = {},
    types     = {},
  },
  dim_inactive    = false,
  transparent     = false,
  terminal_colors = true,
  on_colors       = function(c) end,      -- c.keyword = "#F2B966"
  on_highlights   = function(hl, c) end,  -- hl.Comment = { fg = c.punct }
  overrides       = {},                   -- { Comment = { fg = "#909090" } }
})
```

`intensity` does not change errors and warnings. They stay strong.

`contrast` cannot go below 1.0.

`on_colors` runs before the groups are built. Change a palette role there.
`on_highlights` runs after. Change or add groups there, with the palette
in `c`. `overrides` is applied last and is not contrast-checked.

Everything is upright by default. Most terminal fonts fake italics, and
italics slow reading. Use `styles` if your font has a real italic.

## Focus mode

In focus mode, strings, types, numbers and function names become grey.
Keywords, errors and git signs keep their colour. The brightness of each
token does not change.

## lualine

```lua
require("lualine").setup({ options = { theme = "mesopic" } })  -- or "photopic"
```

`theme = "auto"` also works.

## Extras

`extras/` has the same palette for other programs:

alacritty, delta, fish, foot, fzf, ghostty, kitty, lazygit, starship, tmux,
wezterm, windows terminal, xresources, zellij.

The files are generated from the Lua palette. Do not edit them. To rebuild
them after a palette change:

```sh
nvim -l scripts/build.lua
```

Inside Neovim, lazygit and other terminal programs already match. The
lazygit file is for lazygit in a shell. It has a dark and a light block, so
it follows your terminal.

## Palette

```lua
local c = require("mesopic").palette()
c.keyword  --> "#F8BF6C"
```

| role | dark | light | contrast (dark) |
|---|---|---|---|
| bg | `#1B2025` | `#F7F5EF` | |
| surface | `#262B31` | `#EEEBE4` | |
| border | `#3A4048` | `#D4D1C8` | |
| cursorline | `#23282E` | `#F1EFE8` | |
| selection | `#2D333B` | `#DEDAD1` | |
| fg | `#DADEE3` | `#232A30` | 12.14 |
| function | `#C9DAEB` | `#2A3744` | 11.49 |
| keyword | `#F8BF6C` | `#6F3600` | 9.89 |
| type | `#7EC9D1` | `#006580` | 8.72 |
| string | `#8EC58F` | `#2C6D3E` | 8.23 |
| number | `#D5848A` | `#A64B4E` | 5.86 |
| punctuation | `#9A9FA5` | `#595E64` | 6.15 |
| error | `#FF716B` | `#A80019` | 6.11 |
| warning | `#F59E3B` | `#9A5500` | 7.69 |
| success | `#8FD89E` | `#005725` | 9.75 |
| info | `#80C1E1` | `#216188` | 8.31 |
| doc comment | `#869BB1` | `#52657A` | 5.73 |
| comment | `#858F9A` | `#646F7A` | 4.99 |
| line number | `#70757C` | `#838078` | 3.53 |

The minimum contrast is 4.5 to 1 for text and 3 to 1 for UI lines. All
values pass in both variants, with normal vision and with simulated
protanopia and deuteranopia. The colours in each hue family are spaced in
lightness, so they stay apart when hue is lost.

Diff lines, diagnostic virtual text and LSP references use a tinted
background. The tint is weak, and the text on it stays above 4.5 to 1.

## Supported plugins

Neovim core (0.10, 0.11 and 0.12 groups), treesitter, LSP semantic tokens,
diagnostics, diff, telescope, fzf-lua, snacks.nvim, gitsigns, nvim-cmp,
blink.cmp, neo-tree, nvim-tree, oil, which-key, trouble, indent-blankline,
treesitter-context, render-markdown, mini.nvim, notify, noice, lazy, mason,
flash, leap, harpoon, bufferline, nvim-dap, dap-ui, neotest, diffview,
grug-far, copilot, illuminate, navic, aerial, dashboard, alpha, terminal
colours.

## Tests

```sh
nvim -l scripts/check.lua                 # contrast gate, three vision types
nvim --headless -u tests/init.lua +q      # load test and health check
```

Both run in CI on Linux, macOS and Windows.

## Licence

MIT.
