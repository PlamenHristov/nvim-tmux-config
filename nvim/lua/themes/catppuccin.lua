-- Catppuccin colorscheme (mocha).
return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  config = function()
    require('catppuccin').setup {
      flavour = 'mocha',
      transparent_background = false,
      term_colors = true,
      styles = {
        comments = { 'italic' },
        keywords = { 'bold' },
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        mason = true,
        mini = { enabled = true },
        nvimtree = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
        fidget = true,
        diffview = true,
        indent_blankline = { enabled = true },
        native_lsp = { enabled = true },
      },
    }
    vim.cmd.colorscheme 'catppuccin'
  end,
}
