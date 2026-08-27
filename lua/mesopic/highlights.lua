-- mesopic.nvim | core highlight groups
--
-- Order matters below: legacy syntax groups first, treesitter captures after,
-- because treesitter links fall back to the legacy group when a capture is
-- undefined. Set the base right and most of the tree inherits correctly.

local M = {}

---@param c table palette
---@param o table options
---@return table<string, table>
function M.get(c, o)
  local bg = o.transparent and "NONE" or c.bg
  local none = "NONE"

  return {
    ---------------------------------------------------------------------
    -- editor chrome
    ---------------------------------------------------------------------
    Normal        = { fg = c.fg, bg = bg },
    NormalNC      = { fg = c.fg, bg = o.dim_inactive and c.cline or bg },
    NormalFloat   = { fg = c.fg, bg = c.surface },
    FloatBorder   = { fg = c.border, bg = c.surface },
    FloatTitle    = { fg = c.keyword, bg = c.surface, bold = true },

    Cursor        = { fg = c.bg, bg = c.fg },
    CursorLine    = { bg = c.cline },
    CursorColumn  = { bg = c.cline },
    ColorColumn   = { bg = c.cline },
    CursorLineNr  = { fg = c.fg, bold = true },
    LineNr        = { fg = c.gutter },
    SignColumn    = { bg = bg },
    FoldColumn    = { fg = c.gutter, bg = bg },
    Folded        = { fg = c.comment, bg = c.surface },

    VertSplit     = { fg = c.border },
    WinSeparator  = { fg = c.border },

    Visual        = { bg = c.sel },
    VisualNOS     = { bg = c.sel },
    -- Search is underlined rather than block-inverted. An inverted block is
    -- the harshest element in most themes and it destroys the shape of the
    -- word you are trying to read. The current match still inverts, because
    -- exactly one thing should win.
    Search        = { fg = c.keyword, bg = c.sel, underline = true },
    IncSearch     = { fg = c.bg, bg = c.warn, bold = true },
    CurSearch     = { fg = c.bg, bg = c.warn, bold = true },
    MatchParen    = { fg = c.keyword, bold = true },

    Pmenu         = { fg = c.fg, bg = c.surface },
    PmenuSel      = { fg = c.bg, bg = c.keyword, bold = true },
    PmenuSbar     = { bg = c.overlay },
    PmenuThumb    = { bg = c.gutter },

    StatusLine    = { fg = c.punct, bg = c.surface },
    StatusLineNC  = { fg = c.comment, bg = c.surface },
    TabLine       = { fg = c.comment, bg = c.surface },
    TabLineSel    = { fg = c.fg, bg = bg, bold = true },
    TabLineFill   = { bg = c.surface },
    WinBar        = { fg = c.punct, bg = none },
    WinBarNC      = { fg = c.comment, bg = none },

    Directory     = { fg = c.type },
    Title         = { fg = c.keyword, bold = true },
    Question      = { fg = c.ok },
    MoreMsg       = { fg = c.ok },
    ModeMsg       = { fg = c.fg, bold = true },
    ErrorMsg      = { fg = c.err, bold = true },
    WarningMsg    = { fg = c.warn },
    NonText       = { fg = c.gutter },
    Whitespace    = { fg = c.overlay },
    SpecialKey    = { fg = c.gutter },
    Conceal       = { fg = c.punct },
    EndOfBuffer   = { fg = bg == "NONE" and c.bg or bg },
    QuickFixLine  = { bg = c.sel },
    WildMenu      = { fg = c.bg, bg = c.keyword },

    SpellBad      = { sp = c.err,  undercurl = true },
    SpellCap      = { sp = c.warn, undercurl = true },
    SpellLocal    = { sp = c.info, undercurl = true },
    SpellRare     = { sp = c.num,  undercurl = true },

    ---------------------------------------------------------------------
    -- legacy syntax. neutral by default -- chroma is scarce on purpose.
    -- In focus mode the palette itself has already had chroma stripped from
    -- str/type/num/func, so nothing below needs a special case.
    ---------------------------------------------------------------------
    Identifier    = { fg = c.fg },
    Delimiter     = { fg = c.punct },
    Operator      = { fg = c.punct },
    Comment       = { fg = c.comment, italic = o.italic_comments },

    Function      = { fg = c.func },
    Statement     = { fg = c.keyword },
    Keyword       = { fg = c.keyword },
    Conditional   = { fg = c.keyword },
    Repeat        = { fg = c.keyword },
    Label         = { fg = c.keyword },
    Exception     = { fg = c.keyword },
    Include       = { fg = c.keyword },
    PreProc       = { fg = c.keyword },
    Define        = { fg = c.keyword },
    Macro         = { fg = c.keyword },

    String        = { fg = c.str },
    Character     = { fg = c.str },
    Number        = { fg = c.num },
    Float         = { fg = c.num },
    Boolean       = { fg = c.num },
    Constant      = { fg = c.num },

    Type          = { fg = c.type },
    StorageClass  = { fg = c.type },
    Structure     = { fg = c.type },
    Typedef       = { fg = c.type },

    Special       = { fg = c.num },
    SpecialChar   = { fg = c.num },
    Tag           = { fg = c.type },
    Debug         = { fg = c.err },
    Underlined    = { fg = c.info, underline = true },
    Error         = { fg = c.err },
    Todo          = { fg = c.bg, bg = c.warn, bold = true },

    ---------------------------------------------------------------------
    -- treesitter
    ---------------------------------------------------------------------
    ["@variable"]              = { fg = c.fg },
    ["@variable.builtin"]      = { fg = c.num },
    ["@variable.parameter"]    = { fg = c.fg },
    ["@variable.member"]       = { fg = c.fg },
    ["@property"]              = { fg = c.fg },
    ["@field"]                 = { fg = c.fg },

    ["@punctuation"]           = { fg = c.punct },
    ["@punctuation.bracket"]   = { fg = c.punct },
    ["@punctuation.delimiter"] = { fg = c.punct },
    ["@punctuation.special"]   = { fg = c.punct },
    ["@operator"]              = { fg = c.punct },

    ["@function"]              = { fg = c.func },
    ["@function.call"]         = { fg = c.func },
    ["@function.builtin"]      = { fg = c.func },
    ["@function.method"]       = { fg = c.func },
    ["@function.method.call"]  = { fg = c.func },
    ["@constructor"]           = { fg = c.type },

    ["@keyword"]               = { fg = c.keyword },
    ["@keyword.function"]      = { fg = c.keyword },
    ["@keyword.operator"]      = { fg = c.keyword },
    ["@keyword.import"]        = { fg = c.keyword },
    ["@keyword.conditional"]   = { fg = c.keyword },
    ["@keyword.repeat"]        = { fg = c.keyword },
    ["@keyword.exception"]     = { fg = c.keyword },
    ["@keyword.return"]        = { fg = c.keyword, bold = true },

    ["@string"]                = { fg = c.str },
    ["@string.escape"]         = { fg = c.num },
    ["@string.special"]        = { fg = c.num },
    ["@string.regexp"]         = { fg = c.num },
    ["@character"]             = { fg = c.str },

    ["@number"]                = { fg = c.num },
    ["@boolean"]               = { fg = c.num },
    ["@constant"]              = { fg = c.num },
    ["@constant.builtin"]      = { fg = c.num },
    ["@constant.macro"]        = { fg = c.num },

    ["@type"]                  = { fg = c.type },
    ["@type.builtin"]          = { fg = c.type },
    ["@type.definition"]       = { fg = c.type },
    ["@module"]                = { fg = c.type },
    ["@namespace"]             = { fg = c.type },
    ["@attribute"]             = { fg = c.keyword },
    ["@label"]                 = { fg = c.keyword },

    ["@comment"]               = { fg = c.comment, italic = o.italic_comments },
    ["@comment.error"]         = { fg = c.bg, bg = c.err, bold = true },
    ["@comment.warning"]       = { fg = c.bg, bg = c.warn, bold = true },
    ["@comment.todo"]          = { fg = c.bg, bg = c.info, bold = true },
    ["@comment.note"]          = { fg = c.bg, bg = c.ok, bold = true },

    -- markup (markdown, help files)
    ["@markup.heading"]        = { fg = c.keyword, bold = true },
    ["@markup.strong"]         = { fg = c.fg, bold = true },
    ["@markup.italic"]         = { fg = c.fg, italic = true },
    ["@markup.strikethrough"]  = { fg = c.comment, strikethrough = true },
    ["@markup.link"]           = { fg = c.info, underline = true },
    ["@markup.link.label"]     = { fg = c.type },
    ["@markup.raw"]            = { fg = c.str },
    ["@markup.list"]           = { fg = c.punct },
    ["@markup.quote"]          = { fg = c.comment, italic = true },
    ["@diff.plus"]             = { fg = c.ok },
    ["@diff.minus"]            = { fg = c.err },
    ["@diff.delta"]            = { fg = c.warn },
    ["@tag"]                   = { fg = c.type },
    ["@tag.attribute"]         = { fg = c.fg },
    ["@tag.delimiter"]         = { fg = c.punct },

    ---------------------------------------------------------------------
    -- lsp semantic tokens
    ---------------------------------------------------------------------
    ["@lsp.type.namespace"]     = { link = "@module" },
    ["@lsp.type.type"]          = { link = "@type" },
    ["@lsp.type.class"]         = { link = "@type" },
    ["@lsp.type.enum"]          = { link = "@type" },
    ["@lsp.type.interface"]     = { link = "@type" },
    ["@lsp.type.struct"]        = { link = "@type" },
    ["@lsp.type.parameter"]     = { link = "@variable.parameter" },
    ["@lsp.type.variable"]      = { link = "@variable" },
    ["@lsp.type.property"]      = { link = "@property" },
    ["@lsp.type.enumMember"]    = { link = "@constant" },
    ["@lsp.type.function"]      = { link = "@function" },
    ["@lsp.type.method"]        = { link = "@function.method" },
    ["@lsp.type.macro"]         = { link = "@constant.macro" },
    ["@lsp.type.decorator"]     = { link = "@attribute" },
    ["@lsp.mod.deprecated"]     = { strikethrough = true },

    LspReferenceText            = { bg = c.sel },
    LspReferenceRead            = { bg = c.sel },
    LspReferenceWrite           = { bg = c.sel, underline = true },
    LspInlayHint                = { fg = c.gutter, bg = c.cline },
    LspSignatureActiveParameter = { fg = c.keyword, bold = true },
    LspCodeLens                 = { fg = c.comment },

    ---------------------------------------------------------------------
    -- diagnostics: colour AND a second channel, never hue alone.
    -- roughly 1 in 12 men cannot separate red from green.
    ---------------------------------------------------------------------
    DiagnosticError            = { fg = c.err },
    DiagnosticWarn             = { fg = c.warn },
    DiagnosticInfo             = { fg = c.info },
    DiagnosticHint             = { fg = c.punct },
    DiagnosticOk               = { fg = c.ok },

    DiagnosticVirtualTextError = { fg = c.err,  bg = c.cline },
    DiagnosticVirtualTextWarn  = { fg = c.warn, bg = c.cline },
    DiagnosticVirtualTextInfo  = { fg = c.info, bg = c.cline },
    DiagnosticVirtualTextHint  = { fg = c.punct, bg = c.cline },

    DiagnosticUnderlineError   = { sp = c.err,   undercurl = true },
    DiagnosticUnderlineWarn    = { sp = c.warn,  undercurl = true },
    DiagnosticUnderlineInfo    = { sp = c.info,  undercurl = true },
    DiagnosticUnderlineHint    = { sp = c.punct, undercurl = true },

    DiagnosticSignError        = { fg = c.err },
    DiagnosticSignWarn         = { fg = c.warn },
    DiagnosticSignInfo         = { fg = c.info },
    DiagnosticSignHint         = { fg = c.punct },

    ---------------------------------------------------------------------
    -- diff
    ---------------------------------------------------------------------
    DiffAdd     = { fg = c.ok,   bg = c.cline },
    DiffChange  = { fg = c.warn, bg = c.cline },
    DiffDelete  = { fg = c.err,  bg = c.cline },
    DiffText    = { fg = c.warn, bg = c.sel, bold = true },
    Added       = { fg = c.ok },
    Changed     = { fg = c.warn },
    Removed     = { fg = c.err },
  }
end

return M
