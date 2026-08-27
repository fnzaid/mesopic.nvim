# mesopic.nvim

Two colorschemes for Neovim. `mesopic` for night, `photopic` for day.

Colours are stored in OKLCH and converted at load, so the tuning knobs are
perceptual instead of hex nudging. Every role is contrast-checked and you can
verify it yourself with `:checkhealth mesopic`.

Four colours carry meaning. Everything else is neutral.

## Install

lazy.nvim:

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

packer:

```lua
use({
  "HttoZaid/mesopic.nvim",
  config = function()
    require("mesopic").setup({})
    vim.cmd.colorscheme("mesopic")
  end,
})
```

No plugin manager: clone into `~/.config/nvim/pack/themes/start/`.

## Usage

```vim
:colorscheme mesopic     " night
:colorscheme photopic    " day
:checkhealth mesopic     " measure the live palette
```

## Options

```lua
require("mesopic").setup({
  variant         = "auto",  -- "night" | "day" | "auto" (follows vim.o.background)
  intensity       = 1.0,     -- 0.0 to 1.2, how much colour
  contrast        = 1.0,     -- 1.0 to 1.5, how far text sits from the background
  focus           = false,   -- colour only what needs attention
  italic_comments = false,
  dim_inactive    = false,
  transparent     = false,
  terminal_colors = true,    -- sets vim.g.terminal_color_0..15
  overrides       = {},      -- { Comment = { fg = "#909090" } }
})
```

`intensity` scales chroma. Diagnostics are exempt, so errors stay loud when
everything else is turned down. `contrast` will not go below 1.0.

## Keymaps

```lua
local mesopic = require("mesopic")

-- swap night and day
vim.keymap.set("n", "<leader>ut", function() mesopic.toggle() end)

-- focus mode on/off
vim.keymap.set("n", "<leader>uf", function() mesopic.focus() end)
```

## Focus mode

Strings, types, numbers and function names drop their colour. Keywords,
diagnostics and git signs keep theirs. Brightness is untouched, so nothing
becomes ambiguous. A clean file goes almost monochrome.

## lualine

```lua
require("lualine").setup({ options = { theme = require("mesopic").lualine() } })
```

## lazygit

Inside Neovim it already matches. lazygit draws with the 16 ANSI colours
Neovim exposes, and `terminal_colors = true` sets them.

For lazygit in your shell, merge `extras/lazygit.yml` into
`~/.config/lazygit/config.yml`.

## Palette

```lua
local c = require("mesopic").palette()
c.keyword  --> "#F2B966"
```

| role | night | day | ratio (night) |
|---|---|---|---|
| bg | `#1B2025` | `#F7F5EF` | — |
| surface | `#262B31` | `#EEEBE4` | — |
| border | `#3A4048` | `#D4D1C8` | — |
| cursorline | `#23282E` | `#F1EFE8` | — |
| selection | `#2D333B` | `#DEDAD1` | — |
| fg | `#DADEE3` | `#232A30` | 12.14 |
| function | `#C9DAEB` | `#2A3744` | 11.49 |
| keyword | `#F2B966` | `#7B3C00` | 9.30 |
| type | `#7EC9D1` | `#006580` | 8.72 |
| string | `#89C08A` | `#327243` | 7.79 |
| number | `#DA898F` | `#A64B4E` | 6.22 |
| punctuation | `#9A9FA5` | `#595E64` | 6.15 |
| error | `#FC5855` | `#BB061E` | 5.21 |
| warning | `#F19B37` | `#9A5500` | 7.41 |
| success | `#7CC58C` | `#196632` | 7.99 |
| info | `#80C1E1` | `#216188` | 8.31 |
| comment | `#858F9A` | `#67717D` | 4.99 |
| line number | `#70757C` | `#838078` | 3.53 |

Floors are 4.5:1 for text and 3:1 for UI. Both variants clear them. Run
`:checkhealth mesopic` for the live numbers with your settings applied.

## Covered

treesitter, LSP semantic tokens, diagnostics, diff, telescope, gitsigns,
nvim-cmp, blink.cmp, neo-tree, nvim-tree, oil, which-key, indent-blankline v3,
mini.nvim, notify, noice, trouble, lazy, mason, flash, leap, harpoon,
dashboard, terminal ANSI.

## Licence

MIT.
