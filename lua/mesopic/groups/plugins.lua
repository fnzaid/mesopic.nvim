-- mesopic.nvim | plugin integrations
--
-- Groups are set unconditionally. Setting a highlight for a plugin you do not
-- have costs nothing at runtime and avoids a load-order race, which is the
-- usual reason a colorscheme "does not apply" to a lazily loaded plugin.

local M = {}

function M.get(c, o)
  local bg = o.transparent and "NONE" or c.bg

  return {
    ---------------------------------------------------------------------
    -- telescope
    ---------------------------------------------------------------------
    TelescopeNormal        = { fg = c.fg, bg = c.surface },
    TelescopeBorder        = { fg = c.border, bg = c.surface },
    TelescopeTitle         = { fg = c.bg, bg = c.keyword, bold = true },
    TelescopePromptNormal  = { fg = c.fg, bg = c.overlay },
    TelescopePromptBorder  = { fg = c.overlay, bg = c.overlay },
    TelescopePromptTitle   = { fg = c.bg, bg = c.keyword, bold = true },
    TelescopePromptPrefix  = { fg = c.keyword },
    TelescopeResultsTitle  = { fg = c.surface, bg = c.surface },
    TelescopePreviewTitle  = { fg = c.bg, bg = c.ok, bold = true },
    TelescopeSelection     = { fg = c.fg, bg = c.sel, bold = true },
    TelescopeSelectionCaret= { fg = c.keyword, bg = c.sel },
    TelescopeMatching      = { fg = c.keyword, bold = true },
    TelescopeMultiSelection= { fg = c.ok },

    ---------------------------------------------------------------------
    -- gitsigns
    ---------------------------------------------------------------------
    GitSignsAdd            = { fg = c.ok },
    GitSignsChange         = { fg = c.warn },
    GitSignsDelete         = { fg = c.err },
    GitSignsAddNr          = { fg = c.ok },
    GitSignsChangeNr       = { fg = c.warn },
    GitSignsDeleteNr       = { fg = c.err },
    GitSignsAddInline      = { bg = c.sel },
    GitSignsDeleteInline   = { bg = c.sel },
    GitSignsCurrentLineBlame = { fg = c.gutter, italic = true },

    ---------------------------------------------------------------------
    -- nvim-cmp / blink.cmp
    ---------------------------------------------------------------------
    CmpItemAbbr            = { fg = c.fg },
    CmpItemAbbrDeprecated  = { fg = c.comment, strikethrough = true },
    CmpItemAbbrMatch       = { fg = c.keyword, bold = true },
    CmpItemAbbrMatchFuzzy  = { fg = c.keyword },
    CmpItemMenu            = { fg = c.comment },
    CmpItemKindFunction    = { fg = c.func },
    CmpItemKindMethod      = { fg = c.func },
    CmpItemKindVariable    = { fg = c.fg },
    CmpItemKindField       = { fg = c.fg },
    CmpItemKindProperty    = { fg = c.fg },
    CmpItemKindKeyword     = { fg = c.keyword },
    CmpItemKindText        = { fg = c.str },
    CmpItemKindSnippet     = { fg = c.str },
    CmpItemKindClass       = { fg = c.type },
    CmpItemKindInterface   = { fg = c.type },
    CmpItemKindStruct      = { fg = c.type },
    CmpItemKindModule      = { fg = c.type },
    CmpItemKindConstant    = { fg = c.num },
    CmpItemKindEnumMember  = { fg = c.num },

    BlinkCmpMenu           = { fg = c.fg, bg = c.surface },
    BlinkCmpMenuBorder     = { fg = c.border, bg = c.surface },
    BlinkCmpMenuSelection  = { bg = c.sel, bold = true },
    BlinkCmpLabelMatch     = { fg = c.keyword, bold = true },
    BlinkCmpDoc            = { fg = c.fg, bg = c.surface },
    BlinkCmpDocBorder      = { fg = c.border, bg = c.surface },

    ---------------------------------------------------------------------
    -- neo-tree / nvim-tree / oil
    ---------------------------------------------------------------------
    NeoTreeNormal          = { fg = c.fg, bg = c.surface },
    NeoTreeNormalNC        = { fg = c.fg, bg = c.surface },
    NeoTreeWinSeparator    = { fg = c.border, bg = c.surface },
    NeoTreeDirectoryName   = { fg = c.type },
    NeoTreeDirectoryIcon   = { fg = c.type },
    NeoTreeRootName        = { fg = c.keyword, bold = true },
    NeoTreeGitAdded        = { fg = c.ok },
    NeoTreeGitModified     = { fg = c.warn },
    NeoTreeGitDeleted      = { fg = c.err },
    NeoTreeGitUntracked    = { fg = c.comment },
    NeoTreeIndentMarker    = { fg = c.border },
    NeoTreeCursorLine      = { bg = c.sel },

    NvimTreeNormal         = { fg = c.fg, bg = c.surface },
    NvimTreeFolderName     = { fg = c.type },
    NvimTreeFolderIcon     = { fg = c.type },
    NvimTreeRootFolder     = { fg = c.keyword, bold = true },
    NvimTreeIndentMarker   = { fg = c.border },
    NvimTreeGitDirty       = { fg = c.warn },
    NvimTreeGitNew         = { fg = c.ok },
    NvimTreeGitDeleted     = { fg = c.err },

    OilDir                 = { fg = c.type },
    OilDirIcon             = { fg = c.type },
    OilLink                = { fg = c.info, underline = true },

    ---------------------------------------------------------------------
    -- which-key
    ---------------------------------------------------------------------
    WhichKey               = { fg = c.keyword },
    WhichKeyGroup          = { fg = c.type },
    WhichKeyDesc           = { fg = c.fg },
    WhichKeySeparator      = { fg = c.comment },
    WhichKeyFloat          = { bg = c.surface },
    WhichKeyBorder         = { fg = c.border, bg = c.surface },

    ---------------------------------------------------------------------
    -- indent-blankline v3
    ---------------------------------------------------------------------
    IblIndent              = { fg = c.overlay },
    IblScope               = { fg = c.border },
    IblWhitespace          = { fg = c.overlay },

    ---------------------------------------------------------------------
    -- mini.nvim
    ---------------------------------------------------------------------
    MiniStatuslineModeNormal  = { fg = c.bg, bg = c.keyword, bold = true },
    MiniStatuslineModeInsert  = { fg = c.bg, bg = c.ok, bold = true },
    MiniStatuslineModeVisual  = { fg = c.bg, bg = c.num, bold = true },
    MiniStatuslineModeReplace = { fg = c.bg, bg = c.err, bold = true },
    MiniStatuslineModeCommand = { fg = c.bg, bg = c.info, bold = true },
    MiniStatuslineDevinfo     = { fg = c.punct, bg = c.surface },
    MiniStatuslineFilename    = { fg = c.fg, bg = c.surface },
    MiniIndentscopeSymbol     = { fg = c.border },
    MiniCursorword            = { bg = c.sel },

    ---------------------------------------------------------------------
    -- notify / noice / trouble / lazy / mason
    ---------------------------------------------------------------------
    NotifyERRORBorder = { fg = c.err },   NotifyERRORTitle = { fg = c.err },
    NotifyWARNBorder  = { fg = c.warn },  NotifyWARNTitle  = { fg = c.warn },
    NotifyINFOBorder  = { fg = c.info },  NotifyINFOTitle  = { fg = c.info },
    NotifyDEBUGBorder = { fg = c.punct }, NotifyDEBUGTitle = { fg = c.punct },
    NotifyTRACEBorder = { fg = c.num },   NotifyTRACETitle = { fg = c.num },

    NoiceCmdlinePopupBorder = { fg = c.border },
    NoiceCmdlineIcon        = { fg = c.keyword },
    NoiceConfirmBorder      = { fg = c.border },

    TroubleNormal   = { fg = c.fg, bg = c.surface },
    TroubleText     = { fg = c.fg },
    TroubleCount    = { fg = c.keyword, bg = c.sel },

    LazyNormal      = { fg = c.fg, bg = c.surface },
    LazyButton      = { fg = c.fg, bg = c.overlay },
    LazyButtonActive= { fg = c.bg, bg = c.keyword, bold = true },
    LazyH1          = { fg = c.bg, bg = c.keyword, bold = true },
    LazyProgressDone= { fg = c.ok },
    LazyProgressTodo= { fg = c.border },

    MasonNormal        = { fg = c.fg, bg = c.surface },
    MasonHeader        = { fg = c.bg, bg = c.keyword, bold = true },
    MasonHighlight     = { fg = c.type },
    MasonMuted         = { fg = c.comment },

    ---------------------------------------------------------------------
    -- flash / leap / harpoon / dashboard
    ---------------------------------------------------------------------
    FlashBackdrop = { fg = c.gutter },
    FlashLabel    = { fg = c.bg, bg = c.err, bold = true },
    LeapLabel     = { fg = c.bg, bg = c.err, bold = true },
    LeapBackdrop  = { fg = c.gutter },

    HarpoonBorder = { fg = c.border, bg = c.surface },
    HarpoonWindow = { fg = c.fg, bg = c.surface },

    DashboardHeader  = { fg = c.keyword },
    DashboardCenter  = { fg = c.fg },
    DashboardFooter  = { fg = c.comment },

    ---------------------------------------------------------------------
    -- terminal window background (lazygit, gitui, anything in :terminal)
    ---------------------------------------------------------------------
    TermCursor    = { fg = c.bg, bg = c.fg },
    TermCursorNC  = { bg = c.gutter },
    ToggleTerm1Normal = { bg = bg },
  }
end

return M
