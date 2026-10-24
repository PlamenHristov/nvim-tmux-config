--[[
=====================================================================
Autocommands - Automatic behaviors
=====================================================================
--]]

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Rust-specific keymaps
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'rust',
  callback = function()
    local opts = { buffer = true, noremap = true, silent = true }
    vim.keymap.set('n', '<leader>rc', ':!cargo clippy<CR>', vim.tbl_extend('force', opts, { desc = '[R]ust [C]lippy' }))
    vim.keymap.set('n', '<leader>rf', ':!cargo fmt<CR>', vim.tbl_extend('force', opts, { desc = '[R]ust [F]mt' }))
  end,
})
