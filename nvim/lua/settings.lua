--[[
=====================================================================
Settings - Neovim options and global settings
=====================================================================
--]]

-- Leader keys (must be set before lazy.nvim)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd Font
vim.g.have_nerd_font = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Mouse
vim.opt.mouse = 'a'

-- Appearance
vim.opt.showmode = false
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Clipboard
vim.opt.clipboard = 'unnamedplus'

-- Indentation
vim.opt.breakindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.inccommand = 'split'

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Performance
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Misc
vim.opt.undofile = true
vim.opt.scrolloff = 10
