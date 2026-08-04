--[[
=====================================================================
Keymaps - All keyboard shortcuts
=====================================================================
--]]

-- Clear search highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostics navigation
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, { desc = 'Go to next diagnostic' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic error messages' })

-- Window management
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Close window' })
vim.keymap.set('n', '<C-q>', ':q<CR>', { desc = 'Close window' })
vim.keymap.set('n', '<leader>wc', ':q<CR>', { desc = '[W]indow [C]lose' })
vim.keymap.set('n', '<leader>wo', ':only<CR>', { desc = '[W]indow [O]nly (close others)' })

-- Window navigation (also works with tmux via vim-tmux-navigator style)
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Better indenting (stay in visual mode)
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right' })

-- Quick save
vim.keymap.set('n', '<C-s>', ':w<CR>', { desc = 'Save file' })
