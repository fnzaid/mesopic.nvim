-- Core groups. Legacy syntax groups come first; treesitter captures fall
-- back to them. Backgrounds that carry meaning are tinted toward the
-- semantic hue with color.mix at low strength, which reads as colour
-- without changing the foreground's contrast.

local color = require("mesopic.color")

local M = {}

local function with(base, style)
  return vim.tbl_extend("force", base, style or {})
end

--- Backgrounds pulled toward a semantic hue. Mixing happens in linear
--- light, so a dark ground brightens fast: night uses about half the
--- strength of day. Every strength here keeps its foreground above 4.5:1;
--- scripts/check.lua verifies that.
---@param c table palette
---@return table<string,string>
function M.tints(c)
  local mix = color.mix
  local k = color.luminance(c.bg) < 0.5 and 1 or 2
  return {
    add       = mix(c.bg, c.ok,      0.08 * k),
    del       = mix(c.bg, c.err,     0.08 * k),
    change    = mix(c.bg, c.warn,    0.06 * k),
    text      = mix(c.bg, c.warn,    0.18 * k),
    textadd   = mix(c.bg, c.ok,      0.18 * k),
    delstrong = mix(c.bg, c.err,     0.18 * k),
    err       = mix(c.bg, c.err,     0.05 * k),
    warn      = mix(c.bg, c.warn,    0.05 * k),
    info      = mix(c.bg, c.info,    0.05 * k),
    hint      = mix(c.bg, c.punct,   0.05 * k),
    ok        = mix(c.bg, c.ok,      0.05 * k),
    write     = mix(c.surface, c.warn, 0.10 * k),
    heading   = mix(c.bg, c.keyword, 0.06 * k),
    heading2  = mix(c.bg, c.keyword, 0.035 * k),
  }
end

---@param c table palette
---@param o table options
---@return table<string, table>
function M.get(c, o)
  local bg = o.transparent and "NONE" or c.bg
  local none = "NONE"
  local st = o.styles or {}

  local t = M.tints(c)

  local italic_markup = (st.comments and st.comments.italic) and { italic = true } or { underline = true }

  local g = {
    ---------------------------------------------------------------------
    -- editor chrome
    ---------------------------------------------------------------------
    Normal        = { fg = c.fg, bg = bg },
    NormalNC      = { fg = c.fg, bg = o.dim_inactive and c.cline or bg },
    NormalFloat   = { fg = c.fg, bg = c.surface },
    FloatBorder   = { fg = c.border, bg = c.surface },
    FloatTitle    = { fg = c.keyword, bg = c.surface, bold = true },
    FloatFooter   = { fg = c.comment, bg = c.surface },
    FloatShadow   = { bg = c.bg, blend = 80 },
    FloatShadowThrough = { bg = c.bg, blend = 100 },

    Cursor        = { fg = c.bg, bg = c.fg },
    lCursor       = { link = "Cursor" },
    CursorIM      = { link = "Cursor" },
    TermCursor    = { fg = c.bg, bg = c.fg },
    MCursor       = { fg = c.bg, bg = c.punct },
    MCursorVisual = { bg = c.sel },

    CursorLine    = { bg = c.cline },
    CursorColumn  = { bg = c.cline },
    ColorColumn   = { bg = c.cline },
    CursorLineNr  = { fg = c.fg, bold = true },
    CursorLineSign = { bg = c.cline },
    CursorLineFold = { fg = c.gutter, bg = c.cline },
    LineNr        = { fg = c.gutter },
    LineNrAbove   = { link = "LineNr" },
    LineNrBelow   = { link = "LineNr" },
    SignColumn    = { bg = bg },
    FoldColumn    = { fg = c.gutter, bg = bg },
    -- bg only: with foldtext="" the closed line keeps its syntax colours.
    Folded        = { bg = c.surface },

    VertSplit     = { fg = c.border },
    WinSeparator  = { fg = c.border },

    Visual        = { bg = c.sel },
    VisualNOS     = { bg = c.sel },
    -- Underline, not block invert, so the word keeps its shape. Only the
    -- current match inverts.
    Search        = { fg = c.keyword, bg = c.sel, underline = true },
    IncSearch     = { fg = c.bg, bg = c.warn, bold = true },
    CurSearch     = { fg = c.bg, bg = c.warn, bold = true },
    Substitute    = { link = "IncSearch" },
    MatchParen    = { fg = c.keyword, bold = true },

    Pmenu         = { fg = c.fg, bg = c.surface },
    PmenuSel      = { fg = c.bg, bg = c.keyword, bold = true },
    PmenuMatch    = { fg = c.keyword, bold = true },
    PmenuMatchSel = { fg = c.bg, bg = c.keyword, bold = true, underline = true },
    PmenuKind     = { fg = c.type, bg = c.surface },
    PmenuKindSel  = { fg = c.bg, bg = c.keyword },
    PmenuExtra    = { fg = c.comment, bg = c.surface },
    PmenuExtraSel = { fg = c.bg, bg = c.keyword },
    PmenuBorder   = { fg = c.border, bg = c.surface },
    PmenuSbar     = { bg = c.overlay },
    PmenuThumb    = { bg = c.gutter },
    PmenuShadow   = { link = "FloatShadow" },
    PmenuShadowThrough = { link = "FloatShadowThrough" },
    ComplMatchIns = { fg = c.keyword },
    ComplHint     = { fg = c.gutter },
    ComplHintMore = { fg = c.comment },
    PreInsert     = { fg = c.gutter },
    Menu          = { link = "Pmenu" },
    Scrollbar     = { link = "PmenuSbar" },
    Tooltip       = { link = "Pmenu" },

    StatusLine    = { fg = c.punct, bg = c.surface },
    StatusLineNC  = { fg = c.comment, bg = c.surface },
    StatusLineTerm   = { link = "StatusLine" },
    StatusLineTermNC = { link = "StatusLineNC" },
    TabLine       = { fg = c.comment, bg = c.surface },
    TabLineSel    = { fg = c.fg, bg = bg, bold = true },
    TabLineFill   = { bg = c.surface },
    WinBar        = { fg = c.punct, bg = none },
    WinBarNC      = { fg = c.comment, bg = none },

    MsgArea       = { fg = c.fg },
    MsgSeparator  = { fg = c.border, bg = c.surface },
    ModeMsg       = { fg = c.fg, bold = true },
    MoreMsg       = { fg = c.ok },
    Question      = { fg = c.ok },
    OkMsg         = { fg = c.ok },
    ErrorMsg      = { fg = c.err, bold = true },
    WarningMsg    = { fg = c.warn },
    StderrMsg     = { fg = c.err },
    StdoutMsg     = { fg = c.fg },

    Directory     = { fg = c.type },
    Title         = { fg = c.keyword, bold = true },
    NonText       = { fg = c.gutter },
    Whitespace    = { fg = c.overlay },
    SpecialKey    = { fg = c.gutter },
    Conceal       = { fg = c.punct },
    EndOfBuffer   = { fg = bg == "NONE" and c.bg or bg },
    QuickFixLine  = { bg = c.sel },
    WildMenu      = { fg = c.bg, bg = c.keyword },
    SnippetTabstop       = { bg = c.sel },
    SnippetTabstopActive = { bg = c.sel, underline = true },

    SpellBad      = { sp = c.err,  undercurl = true },
    SpellCap      = { sp = c.warn, undercurl = true },
    SpellLocal    = { sp = c.info, undercurl = true },
    SpellRare     = { sp = c.num,  undercurl = true },

    ---------------------------------------------------------------------
    -- diff
    ---------------------------------------------------------------------
    DiffAdd     = { bg = t.add },
    DiffChange  = { bg = t.change },
    DiffDelete  = { bg = t.del },
    DiffText    = { bg = t.text, bold = true },
    DiffTextAdd = { bg = t.textadd },
    Added       = { fg = c.ok },
    Changed     = { fg = c.warn },
    Removed     = { fg = c.err },

    ---------------------------------------------------------------------
    -- legacy syntax
    ---------------------------------------------------------------------
    Identifier    = with({ fg = c.fg }, st.variables),
    Delimiter     = { fg = c.punct },
    Operator      = { fg = c.punct },
    Comment       = with({ fg = c.comment }, st.comments),
    SpecialComment = with({ fg = c.doc }, st.comments),

    Function      = with({ fg = c.func, bold = true }, st.functions),
    Statement     = with({ fg = c.keyword }, st.keywords),
    Keyword       = with({ fg = c.keyword }, st.keywords),
    Conditional   = with({ fg = c.keyword }, st.keywords),
    Repeat        = with({ fg = c.keyword }, st.keywords),
    Label         = with({ fg = c.keyword }, st.keywords),
    Exception     = with({ fg = c.keyword }, st.keywords),
    Include       = with({ fg = c.keyword }, st.keywords),
    PreProc       = with({ fg = c.keyword }, st.keywords),
    Define        = with({ fg = c.keyword }, st.keywords),
    Macro         = with({ fg = c.keyword }, st.keywords),
    PreCondit     = with({ fg = c.keyword }, st.keywords),

    String        = with({ fg = c.str }, st.strings),
    Character     = with({ fg = c.str }, st.strings),
    Number        = { fg = c.num },
    Float         = { fg = c.num },
    Boolean       = { fg = c.num },
    Constant      = { fg = c.num },

    Type          = with({ fg = c.type }, st.types),
    StorageClass  = with({ fg = c.type }, st.types),
    Structure     = with({ fg = c.type }, st.types),
    Typedef       = with({ fg = c.type }, st.types),

    Special       = { fg = c.num },
    SpecialChar   = { fg = c.num },
    Tag           = { fg = c.type },
    Debug         = { fg = c.err },
    Underlined    = { fg = c.info, underline = true },
    Ignore        = { fg = c.gutter },
    Error         = { fg = c.err },
    Todo          = { fg = c.bg, bg = c.warn, bold = true },

    ---------------------------------------------------------------------
    -- treesitter
    ---------------------------------------------------------------------
    ["@variable"]                   = with({ fg = c.fg }, st.variables),
    ["@variable.builtin"]           = { fg = c.num },
    ["@variable.parameter"]         = with({ fg = c.fg }, st.variables),
    ["@variable.parameter.builtin"] = { fg = c.num },
    ["@variable.member"]            = with({ fg = c.fg }, st.variables),
    ["@property"]                   = with({ fg = c.fg }, st.variables),
    ["@field"]                      = with({ fg = c.fg }, st.variables),

    ["@punctuation"]           = { fg = c.punct },
    ["@punctuation.bracket"]   = { fg = c.punct },
    ["@punctuation.delimiter"] = { fg = c.punct },
    ["@punctuation.special"]   = { fg = c.punct },
    ["@operator"]              = { fg = c.punct },

    -- Definitions are bold: a weight cue for the names readers scan for
    -- that also survives colour-vision deficiency. Calls stay plain.
    ["@function"]              = with({ fg = c.func, bold = true }, st.functions),
    ["@function.call"]         = with({ fg = c.func }, st.functions),
    ["@function.builtin"]      = with({ fg = c.func }, st.functions),
    ["@function.macro"]        = with({ fg = c.func }, st.functions),
    ["@function.method"]       = with({ fg = c.func, bold = true }, st.functions),
    ["@function.method.call"]  = with({ fg = c.func }, st.functions),
    ["@constructor"]           = with({ fg = c.type }, st.types),

    ["@keyword"]                     = with({ fg = c.keyword }, st.keywords),
    ["@keyword.coroutine"]           = with({ fg = c.keyword }, st.keywords),
    ["@keyword.function"]            = with({ fg = c.keyword }, st.keywords),
    ["@keyword.operator"]            = with({ fg = c.keyword }, st.keywords),
    ["@keyword.import"]              = with({ fg = c.keyword }, st.keywords),
    ["@keyword.type"]                = with({ fg = c.keyword }, st.keywords),
    ["@keyword.modifier"]            = with({ fg = c.keyword }, st.keywords),
    ["@keyword.repeat"]              = with({ fg = c.keyword }, st.keywords),
    ["@keyword.return"]              = with({ fg = c.keyword, bold = true }, st.keywords),
    ["@keyword.debug"]               = with({ fg = c.keyword }, st.keywords),
    ["@keyword.exception"]           = with({ fg = c.keyword }, st.keywords),
    ["@keyword.conditional"]         = with({ fg = c.keyword }, st.keywords),
    ["@keyword.conditional.ternary"] = { fg = c.punct },
    ["@keyword.directive"]           = with({ fg = c.keyword }, st.keywords),
    ["@keyword.directive.define"]    = with({ fg = c.keyword }, st.keywords),

    ["@string"]                 = with({ fg = c.str }, st.strings),
    ["@string.documentation"]   = with({ fg = c.doc }, st.comments),
    ["@string.regexp"]          = { fg = c.num },
    ["@string.escape"]          = { fg = c.num },
    ["@string.special"]         = { fg = c.num },
    ["@string.special.symbol"]  = { fg = c.num },
    ["@string.special.url"]     = { fg = c.info, underline = true },
    ["@string.special.path"]    = { fg = c.info, underline = true },
    ["@character"]              = with({ fg = c.str }, st.strings),
    ["@character.special"]      = { fg = c.num },

    ["@number"]                = { fg = c.num },
    ["@number.float"]          = { fg = c.num },
    ["@boolean"]               = { fg = c.num },
    ["@constant"]              = { fg = c.num },
    ["@constant.builtin"]      = { fg = c.num },
    ["@constant.macro"]        = { fg = c.num },

    ["@type"]                  = with({ fg = c.type }, st.types),
    ["@type.builtin"]          = with({ fg = c.type }, st.types),
    ["@type.definition"]       = with({ fg = c.type }, st.types),
    ["@module"]                = with({ fg = c.type }, st.types),
    ["@module.builtin"]        = with({ fg = c.type }, st.types),
    ["@namespace"]             = with({ fg = c.type }, st.types),
    ["@attribute"]             = with({ fg = c.keyword }, st.keywords),
    ["@attribute.builtin"]     = with({ fg = c.keyword }, st.keywords),
    ["@label"]                 = with({ fg = c.keyword }, st.keywords),

    ["@comment"]               = with({ fg = c.comment }, st.comments),
    ["@comment.documentation"] = with({ fg = c.doc }, st.comments),
    ["@comment.error"]         = { fg = c.bg, bg = c.err, bold = true },
    ["@comment.warning"]       = { fg = c.bg, bg = c.warn, bold = true },
    ["@comment.todo"]          = { fg = c.bg, bg = c.info, bold = true },
    ["@comment.note"]          = { fg = c.bg, bg = c.ok, bold = true },

    -- markup: heading levels step by lightness and weight, not hue
    ["@markup.heading"]        = { fg = c.keyword, bold = true },
    ["@markup.heading.1"]      = { fg = c.keyword, bold = true },
    ["@markup.heading.2"]      = { fg = c.keyword, bold = true },
    ["@markup.heading.3"]      = { fg = c.keyword },
    ["@markup.heading.4"]      = { fg = c.func, bold = true },
    ["@markup.heading.5"]      = { fg = c.func },
    ["@markup.heading.6"]      = { fg = c.fg, bold = true },
    ["@markup.heading.1.marker"] = { fg = c.punct },
    ["@markup.heading.2.marker"] = { fg = c.punct },
    ["@markup.heading.3.marker"] = { fg = c.punct },
    ["@markup.heading.4.marker"] = { fg = c.punct },
    ["@markup.heading.5.marker"] = { fg = c.punct },
    ["@markup.heading.6.marker"] = { fg = c.punct },
    ["@markup.strong"]         = { fg = c.fg, bold = true },
    ["@markup.italic"]         = with({ fg = c.fg }, italic_markup),
    ["@markup.underline"]      = { underline = true },
    ["@markup.strikethrough"]  = { fg = c.comment, strikethrough = true },
    ["@markup.link"]           = { fg = c.info, underline = true },
    ["@markup.link.label"]     = { fg = c.type },
    ["@markup.link.url"]       = { fg = c.info, underline = true },
    ["@markup.raw"]            = { fg = c.str },
    ["@markup.raw.block"]      = { fg = c.str, bg = c.surface },
    ["@markup.math"]           = { fg = c.num },
    ["@markup.list"]           = { fg = c.punct },
    ["@markup.list.checked"]   = { fg = c.ok },
    ["@markup.list.unchecked"] = { fg = c.punct },
    ["@markup.quote"]          = with({ fg = c.comment }, italic_markup),
    ["@diff.plus"]             = { fg = c.ok },
    ["@diff.minus"]            = { fg = c.err },
    ["@diff.delta"]            = { fg = c.warn },
    ["@tag"]                   = { fg = c.type },
    ["@tag.builtin"]           = { fg = c.type },
    ["@tag.attribute"]         = { fg = c.fg },
    ["@tag.delimiter"]         = { fg = c.punct },

    ---------------------------------------------------------------------
    -- lsp semantic tokens. Neovim links @lsp.type.* to the captures above;
    -- only the cases that need a different answer are listed.
    ---------------------------------------------------------------------
    ["@lsp.type.variable"]      = {},  -- let treesitter decide (builtin, parameter...)
    ["@lsp.type.comment"]       = { link = "@comment" },
    ["@lsp.type.keyword"]       = { link = "@keyword" },
    ["@lsp.type.namespace"]     = { link = "@module" },
    ["@lsp.type.type"]          = { link = "@type" },
    ["@lsp.type.class"]         = { link = "@type" },
    ["@lsp.type.enum"]          = { link = "@type" },
    ["@lsp.type.interface"]     = { link = "@type" },
    ["@lsp.type.struct"]        = { link = "@type" },
    ["@lsp.type.parameter"]     = { link = "@variable.parameter" },
    ["@lsp.type.property"]      = { link = "@property" },
    ["@lsp.type.enumMember"]    = { link = "@constant" },
    ["@lsp.type.function"]      = { link = "@function.call" },
    ["@lsp.type.method"]        = { link = "@function.method.call" },
    ["@lsp.type.macro"]         = { link = "@constant.macro" },
    ["@lsp.type.decorator"]     = { link = "@attribute" },
    ["@lsp.type.unresolvedReference"] = { sp = c.err, undercurl = true },
    ["@lsp.mod.deprecated"]     = { strikethrough = true },
    ["@lsp.typemod.function.declaration"]      = { link = "@function" },
    ["@lsp.typemod.method.declaration"]        = { link = "@function.method" },
    ["@lsp.typemod.function.defaultLibrary"]   = { link = "@function.builtin" },
    ["@lsp.typemod.method.defaultLibrary"]     = { link = "@function.builtin" },
    ["@lsp.typemod.variable.defaultLibrary"]   = { link = "@variable.builtin" },
    ["@lsp.typemod.type.defaultLibrary"]       = { link = "@type.builtin" },
    ["@lsp.typemod.class.defaultLibrary"]      = { link = "@type.builtin" },
    ["@lsp.typemod.variable.readonly"]         = { link = "@constant" },
    ["@lsp.typemod.variable.static"]           = { link = "@constant" },
    ["@lsp.typemod.variable.global"]           = { link = "@constant" },
    ["@lsp.typemod.keyword.async"]             = { link = "@keyword.coroutine" },

    LspReferenceText            = { bg = c.surface },
    LspReferenceRead            = { bg = c.surface },
    LspReferenceWrite           = { bg = t.write },
    LspReferenceTarget          = { bg = c.sel },
    LspInlayHint                = { fg = c.gutter },
    LspSignatureActiveParameter = { fg = c.keyword, bold = true },
    LspCodeLens                 = { fg = c.gutter },
    LspCodeLensSeparator        = { fg = c.border },

    ---------------------------------------------------------------------
    -- diagnostics: colour plus a second channel (sign, undercurl, tint),
    -- never hue alone.
    ---------------------------------------------------------------------
    DiagnosticError            = { fg = c.err },
    DiagnosticWarn             = { fg = c.warn },
    DiagnosticInfo             = { fg = c.info },
    DiagnosticHint             = { fg = c.punct },
    DiagnosticOk               = { fg = c.ok },

    DiagnosticVirtualTextError = { fg = c.err,   bg = t.err },
    DiagnosticVirtualTextWarn  = { fg = c.warn,  bg = t.warn },
    DiagnosticVirtualTextInfo  = { fg = c.info,  bg = t.info },
    DiagnosticVirtualTextHint  = { fg = c.punct, bg = t.hint },
    DiagnosticVirtualTextOk    = { fg = c.ok,    bg = t.ok },

    DiagnosticVirtualLinesError = { fg = c.err },
    DiagnosticVirtualLinesWarn  = { fg = c.warn },
    DiagnosticVirtualLinesInfo  = { fg = c.info },
    DiagnosticVirtualLinesHint  = { fg = c.punct },
    DiagnosticVirtualLinesOk    = { fg = c.ok },

    DiagnosticFloatingError    = { fg = c.err,   bg = c.surface },
    DiagnosticFloatingWarn     = { fg = c.warn,  bg = c.surface },
    DiagnosticFloatingInfo     = { fg = c.info,  bg = c.surface },
    DiagnosticFloatingHint     = { fg = c.punct, bg = c.surface },
    DiagnosticFloatingOk       = { fg = c.ok,    bg = c.surface },

    DiagnosticUnderlineError   = { sp = c.err,   undercurl = true },
    DiagnosticUnderlineWarn    = { sp = c.warn,  underline = true },
    DiagnosticUnderlineInfo    = { sp = c.info,  underline = true },
    DiagnosticUnderlineHint    = { sp = c.punct, underline = true },
    DiagnosticUnderlineOk      = { sp = c.ok,    underline = true },

    DiagnosticSignError        = { fg = c.err },
    DiagnosticSignWarn         = { fg = c.warn },
    DiagnosticSignInfo         = { fg = c.info },
    DiagnosticSignHint         = { fg = c.punct },
    DiagnosticSignOk           = { fg = c.ok },

    DiagnosticUnnecessary      = { fg = c.comment },
    DiagnosticDeprecated       = { strikethrough = true },
  }

  return g
end

return M
