# mesopic.nvim

Two colorschemes. `mesopic` for night, `photopic` for day.

Built by picking colours in OKLCH and measuring the contrast of every single
one, instead of nudging hex values until they looked nice. The whole palette
is 14 colours and four of them carry meaning.

```
:colorscheme mesopic
:colorscheme photopic
```

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

Or drop the repo in `~/.config/nvim/pack/themes/start/`.

## Options

```lua
require("mesopic").setup({
  variant         = "auto",  -- "night" | "day" | "auto" (follows vim.o.background)
  italic_comments = false,
  dim_inactive    = false,
  transparent     = false,
  terminal_colors = true,
  overrides       = {},
})
```

`italic_comments` defaults off. Most monospace fonts in most terminals have no
real italic face, so the terminal slants the upright glyphs instead. Slanted
bitmaps are harder to read at small sizes, not easier. Turn it on if your font
actually ships an italic.

Toggle without restarting:

```lua
vim.keymap.set("n", "<leader>ut", function() require("mesopic").toggle() end)
```

## lazygit

Two cases, and they get mixed up constantly.

Inside Neovim, lazygit never sees your colorscheme. It draws with the 16 ANSI
colours Neovim exposes as `vim.g.terminal_color_0..15`. `terminal_colors = true`
sets all sixteen, so lazygit, gitui, fzf and htop match without further work.

Outside Neovim, lazygit doesn't know your editor exists. Merge
`extras/lazygit.yml` into `~/.config/lazygit/config.yml`.

## lualine

```lua
require("lualine").setup({ options = { theme = require("mesopic").lualine() } })
```

## Palette access

```lua
local c = require("mesopic").palette()
c.keyword  --> "#EBB25F"
```

## Covered

treesitter, LSP semantic tokens, diagnostics, diff, telescope, gitsigns,
nvim-cmp, blink.cmp, neo-tree, nvim-tree, oil, which-key, indent-blankline v3,
mini.nvim, notify, noice, trouble, lazy, mason, flash, leap, harpoon,
dashboard, terminal ANSI.

---

## Why it looks like this

**Four colours, not twelve.** Identifiers, properties and punctuation are
neutral, because they are most of what's on screen. Colour goes to control
flow, string data, types, and errors. If everything is coloured, nothing is.

The honest version of the evidence: syntax highlighting helps less than people
assume. Sarkar (2015, eye-tracking, n=10) measured about 8.4 seconds faster
task completion and fewer context switches, but no effect on fixation count or
duration, and **the benefit shrank as programming experience went up**.
Beelders and du Plessis (2016) found uncoloured code produced more fixations
and regressions, but not significantly, while participants reported the
coloured version *felt* easier. Small studies, modest effects, partly
aesthetic. That argues for restraint, not for a rainbow.

**Blue is a bad carrier for small text.** The eye's refractive index falls as
wavelength rises, so short wavelengths focus in front of the retina and long
ones behind it, roughly 2 dioptres of spread across the visible spectrum.
Accommodation settles around 550-570 nm, leaving blue cones permanently about
a dioptre defocused. A 2024 study measuring this directly found acuity was
worst under narrowband blue, and ruled out sparse S-cone spacing as the cause
since stimuli were equal luminance.

What the same study did *not* find: any evidence that this tires you out.
Accommodative errors were small and acuity otherwise normal. So the popular
claim that blue text makes your focusing muscle hunt all evening is not
supported. The cost is resolution, not fatigue. Types here use a desaturated
teal, and that's the reason.

**Dark grey ground, off-white text.** Bright glyphs on a near-black field
bleed at the edges (halation), worse with astigmatism. Night sits at 27,32,37
with text at 218,222,227, about 12:1. Not the 21:1 of white on black, which is
past the point where text starts to glow.

Caveat: the widely quoted "50% of people have astigmatism so dark mode fails
half your users" traces back through blog citing blog to a single 2002 web
page. Not a study. A real measurement of 2,523 US children aged 5-17 found
over 28% had astigmatism of 1.0 dioptre or more. The effect is real. The
famous number is folklore.

**Hues differ in lightness, not only hue.** Edge and shape perception runs
mostly on luminance. Two equally bright colours make a boundary the form
pathway resolves poorly, which is why some palettes look fine as swatches and
turn to mush in real code.

**Status never rides on hue alone.** About 1 in 12 men of Northern European
descent can't separate red from green. Errors get colour, an undercurl, and a
gutter sign. Remove the colour and two signals survive.

---

## The part that argues against this theme

The reading research favours light mode, and it isn't close.

The "positive polarity advantage" — dark text on light background beating
light on dark — shows up repeatedly with medium to large effect sizes.
Piepenbrock, Mayr and Buchner (2014) reported d = 0.68 for speed and d = 0.77
for accuracy. The mechanism is boring and well supported: a brighter screen
constricts the pupil, a smaller pupil gives a sharper retinal image, and you
read better. They confirmed it directly by measuring pupil size during
proofreading. Taptagaporn and Saito found *less* visual fatigue with positive
polarity, measured by how often pupil size changed, plus faster accommodation.

Worse for dark mode: the advantage is largest at small character sizes. Which
is code.

It isn't unanimous — Creed et al. (1988), Gould et al. (1987) and others found
no polarity effect — but the weight of it leans one way.

So `photopic` is the variant the evidence supports for long sessions, and it
got the same care as the night one rather than being an afterthought. If you
code at night in a dark room the calculation shifts, since the advantage comes
from display luminance, and a bright screen in a dark room is its own problem.
Use whichever you'll actually keep using. A theme you abandon helps nobody.

And a theme cannot fix eye strain anyway. That's mostly blink rate,
accommodation at a fixed near distance, and ambient lighting. Look at
something far away every 20 minutes. That will do more than any palette.

One more, since it comes up: the 2023 Cochrane review of 17 randomised trials
found blue-light filtering glasses probably make no difference to eye strain,
visual performance, or sleep. Screen blue light is around a thousandth of what
you get from daylight. Don't buy the glasses.

---

## Contrast, measured

Night, against `#1B2025`:

| role | hex | ratio |
|---|---|---|
| fg | `#DADEE3` | 12.14 |
| function | `#C9DAEB` | 11.49 |
| keyword | `#EBB25F` | 8.65 |
| type | `#83C8D0` | 8.70 |
| string | `#93C794` | 8.47 |
| number | `#EBA0A5` | 7.89 |
| punctuation | `#9A9FA5` | 6.15 |
| error | `#FC5855` | 5.21 |
| comment | `#858F9A` | 4.99 |
| line number | `#70757C` | 3.53 |

Day clears the same floors against `#F7F5EF`; comment sits at 4.55.

Floors are 4.5:1 for anything carrying text and 3:1 for structural UI. Change
a colour and re-measure it. A palette is a system, and a colour that looks
better on its own often reads worse in place.

## Licence

MIT.
