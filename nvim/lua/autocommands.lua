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

-- Go-specific keymaps
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    local opts = { buffer = true, noremap = true, silent = true }
    vim.keymap.set('n', '<leader>Gv', ':!go vet ./...<CR>', vim.tbl_extend('force', opts, { desc = '[G]o [V]et' }))
    vim.keymap.set('n', '<leader>Gf', ':!go fmt ./...<CR>', vim.tbl_extend('force', opts, { desc = '[G]o [F]mt' }))
    vim.keymap.set('n', '<leader>Gl', ':!golangci-lint run<CR>', vim.tbl_extend('force', opts, { desc = '[G]o [L]int' }))
  end,
})
