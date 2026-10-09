-- IntelliJ/RustRover-like colorscheme: onedark (warmer) with Darcula-style highlights.
-- Select it in init.lua by requiring 'themes.intellij-darcula' instead of 'themes.catppuccin'.
return {
  'navarasu/onedark.nvim',
  priority = 1000,
  config = function()
    require('onedark').setup {
      style = 'warmer',
      transparent = false,
      term_colors = true,
      colors = { fg = '#BCBEC4' },
      code_style = {
        comments = 'italic',
        keywords = 'none',
        functions = 'none',
        strings = 'none',
        variables = 'none',
      },
      -- RustRover/IntelliJ Darcula-like highlighting
      highlights = {
        -- Keywords (orange like IntelliJ)
        ['@keyword'] = { fg = '#CF8E6D' },
        ['@keyword.function'] = { fg = '#CF8E6D' },
        ['@keyword.return'] = { fg = '#CF8E6D' },
        ['@keyword.operator'] = { fg = '#CF8E6D' },
        ['@keyword.conditional'] = { fg = '#CF8E6D' },
        ['@keyword.repeat'] = { fg = '#CF8E6D' },
        ['@keyword.import'] = { fg = '#CF8E6D' },
        ['@keyword.modifier'] = { fg = '#CF8E6D' },
        ['@keyword.type'] = { fg = '#CF8E6D' },
        ['@keyword.exception'] = { fg = '#CF8E6D' },
        ['@keyword.directive'] = { fg = '#CF8E6D' },

        -- Types (olive)
        ['@type'] = { fg = '#85995D' },
        ['@type.builtin'] = { fg = '#CF8E6D' },
        ['@type.qualifier'] = { fg = '#CF8E6D' },

        -- Functions (blue)
        ['@function'] = { fg = '#57A8F5' },
        ['@function.call'] = { fg = '#57A8F5' },
        ['@function.method'] = { fg = '#57A8F5' },
        ['@function.method.call'] = { fg = '#57A8F5' },
        ['@function.macro'] = { fg = '#4DADE5' },
        ['@function.builtin'] = { fg = '#57A8F5' },
        ['@constructor'] = { fg = '#57A8F5' },

        -- Strings (green)
        ['@string'] = { fg = '#6A8759' },
        ['@string.escape'] = { fg = '#CF8E6D' },
        ['@string.special'] = { fg = '#CF8E6D' },
        ['@string.special.path'] = { fg = '#6A8759', fmt = 'underline' },
        ['@string.special.symbol'] = { fg = '#CF8E6D' },
        ['@character.special'] = { fg = '#CF8E6D' },

        -- Comments (gray italic)
        ['@comment'] = { fg = '#7A7E85', fmt = 'italic' },
        ['@comment.documentation'] = { fg = '#5F826B', fmt = 'italic' },

        -- Variables
        ['@variable'] = { fg = '#BCBEC4' },
        ['@variable.parameter'] = { fg = '#BCBEC4' },
        ['@variable.member'] = { fg = '#C77DBB' },
        ['@variable.builtin'] = { fg = '#DA8FB4' },
        ['@variable.builtin'] = { fg = '#DA8FB4' },

        -- Constants (magenta italic)
        ['@constant'] = { fg = '#C77DBB', fmt = 'italic' },
        ['@constant.builtin'] = { fg = '#CF8E6D' },

        -- Numbers (blue)
        ['@number'] = { fg = '#6897BB' },
        ['@number.float'] = { fg = '#6897BB' },
        ['@boolean'] = { fg = '#CF8E6D' },

        -- Operators and punctuation
        ['@operator'] = { fg = '#BCBEC4' },
        ['@punctuation'] = { fg = '#BCBEC4' },
        ['@punctuation.bracket'] = { fg = '#BCBEC4' },
        ['@punctuation.delimiter'] = { fg = '#BCBEC4' },

        -- Modules/namespaces (default text; crate roots are lavender via LSP)
        ['@module'] = { fg = '#BCBEC4' },
        ['@namespace'] = { fg = '#BCBEC4' },

        -- Attributes (yellow-green for #[derive], etc.)
        ['@attribute'] = { fg = '#BBB529' },
        ['@attribute.builtin'] = { fg = '#BBB529' },

        -- Labels/lifetimes (teal italic)
        ['@label'] = { fg = '#20999D', fmt = 'italic' },

        -- Properties/fields (magenta)
        ['@property'] = { fg = '#C77DBB' },

        -- LSP Semantic Tokens (these override treesitter when available)
        ['@lsp.type.namespace'] = { fg = '#BCBEC4' },
        ['@lsp.typemod.namespace.crateRoot'] = { fg = '#8D91DC' },
        ['@lsp.type.keyword'] = { fg = '#CF8E6D' },
        ['@lsp.type.type'] = { fg = '#85995D' },
        ['@lsp.type.class'] = { fg = '#85995D' },
        ['@lsp.type.struct'] = { fg = '#85995D' },
        ['@lsp.type.union'] = { fg = '#85995D' },
        ['@lsp.type.enum'] = { fg = '#85995D', fmt = 'italic' },
        ['@lsp.type.typeAlias'] = { fg = '#85995D', fmt = 'italic' },
        ['@lsp.type.interface'] = { fg = '#8D91DC' },
        ['@lsp.type.const'] = { fg = '#C77DBB', fmt = 'italic' },
        ['@lsp.type.typeParameter'] = { fg = '#20999D' },
        ['@lsp.type.parameter'] = { fg = '#BCBEC4' },
        ['@lsp.type.variable'] = { fg = '#BCBEC4' },
        ['@lsp.type.property'] = { fg = '#C77DBB' },
        ['@lsp.type.enumMember'] = { fg = '#6DA2AB', fmt = 'italic' },
        ['@lsp.type.function'] = { fg = '#57A8F5' },
        ['@lsp.type.method'] = { fg = '#57A8F5' },
        ['@lsp.type.macro'] = { fg = '#4DADE5' },
        ['@lsp.type.decorator'] = { fg = '#BBB529' },
        ['@lsp.type.lifetime'] = { fg = '#20999D', fmt = 'italic' },
        ['@lsp.type.selfKeyword'] = { fg = '#DA8FB4' },
        ['@lsp.typemod.comment.documentation'] = { fg = '#5F826B', fmt = 'italic' },
        ['@lsp.type.selfTypeKeyword'] = { fg = '#B5B6E3' },
        ['@lsp.type.builtinType'] = { fg = '#CF8E6D' },
        ['@lsp.type.formatSpecifier'] = { fg = '#CF8E6D' },
        ['@lsp.type.escapeSequence'] = { fg = '#CF8E6D' },
        ['@lsp.type.attributeBracket'] = { fg = '#BBB529' },
        ['@lsp.type.derive'] = { fg = '#57A8F5' },
        ['@lsp.type.deriveHelper'] = { fg = '#BBB529' },
        ['@lsp.type.generic'] = { fg = '#B5B6E3' },

        -- Modifiers
        ['@lsp.mod.consuming'] = { fmt = 'italic' },
        ['@lsp.mod.unsafe'] = { fg = '#FF6B68' },
        ['@lsp.mod.async'] = { fmt = 'italic' },
        ['@lsp.typemod.function.trait'] = { fg = '#57A8F5' },
        ['@lsp.typemod.method.trait'] = { fg = '#57A8F5' },

        -- UI elements (Darcula-like)
        CursorLine = { bg = '#323232' },
        CursorLineNr = { fg = '#BCBEC4', fmt = 'bold' },
        Visual = { bg = '#214283' },
        Search = { fg = '#FFFFFF', bg = '#32593D' },
        IncSearch = { fg = '#FFFFFF', bg = '#5E4D1A' },
        LineNr = { fg = '#606366' },
        SignColumn = { bg = '#2B2B2B' },
        NormalFloat = { bg = '#3C3F41' },
        FloatBorder = { fg = '#5E5E5E', bg = '#3C3F41' },
        Pmenu = { bg = '#3C3F41' },
        PmenuSel = { bg = '#4B6EAF' },

        -- Diagnostics
        DiagnosticError = { fg = '#FF6B68' },
        DiagnosticWarn = { fg = '#BE9117' },
        DiagnosticInfo = { fg = '#6897BB' },
        DiagnosticHint = { fg = '#6A8759' },

        -- Inlay hints (subtle gray like IntelliJ)
        LspInlayHint = { fg = '#868A91', bg = '#2A2C30' },
        IblIndent = { fg = '#313438' },
        IblScope = { fg = '#4E5157' },
      },
    }
    vim.cmd.colorscheme 'onedark'

    -- Solidity-only capture tuning (language-scoped, does not touch Rust/TS)
    local function solidity_highlights()
      -- Elementary value types (uint256/address/bool/bytes) — teal, distinct from orange keywords
      vim.api.nvim_set_hl(0, '@type.builtin.solidity', { fg = '#4EC9B0' })
      -- Contract/interface/library/struct/enum names — light purple type color
      vim.api.nvim_set_hl(0, '@type.solidity', { fg = '#B5B6E3' })
      -- Modifiers/visibility (public/private/view/pure/payable) — orange bold, IntelliJ-style
      vim.api.nvim_set_hl(0, '@keyword.modifier.solidity', { fg = '#CF8E6D', bold = true })
      -- NatSpec doc comments — green italic
      vim.api.nvim_set_hl(0, '@comment.documentation.solidity', { fg = '#629755', italic = true })
      -- Global builtins (require/keccak256/ecrecover/selfdestruct) — gold
      vim.api.nvim_set_hl(0, '@function.builtin.solidity', { fg = '#FFC66D' })
    end
    solidity_highlights()
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'onedark',
      callback = solidity_highlights,
    })
  end,
}
