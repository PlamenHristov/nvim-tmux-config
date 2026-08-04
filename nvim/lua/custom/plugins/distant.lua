-- Remote development over SSH (distant.nvim).
-- To remove: delete this file and remove the `{ import = 'custom.plugins' }`
-- entry from ~/.config/nvim/init.lua.
--
-- First-time setup after :Lazy installs the plugin:
--   :DistantInstall          -- fetches the `distant` CLI binary (~/.local/bin)
--   :DistantLaunch <host>    -- spawns a session on the remote (uses ~/.ssh/config)
--   :edit distant://<path>   -- open remote files; LSP/treesitter run on the server
--
-- Keymaps below sit under <leader>r (Remote) and show up in which-key.
return {
  {
    'chipsenkbeil/distant.nvim',
    branch = 'v0.3',
    cmd = {
      'DistantInstall',
      'DistantLaunch',
      'DistantConnect',
      'DistantOpen',
      'DistantShell',
      'DistantSessionInfo',
    },
    keys = {
      { '<leader>rl', '<cmd>DistantLaunch<cr>', desc = '[R]emote [L]aunch' },
      { '<leader>rc', '<cmd>DistantConnect<cr>', desc = '[R]emote [C]onnect' },
      { '<leader>ro', '<cmd>DistantOpen<cr>', desc = '[R]emote [O]pen file' },
      { '<leader>rs', '<cmd>DistantShell<cr>', desc = '[R]emote [S]hell' },
      { '<leader>ri', '<cmd>DistantSessionInfo<cr>', desc = '[R]emote session [I]nfo' },
    },
    config = function()
      require('distant'):setup({
        -- Empty {} keeps distant's defaults; the plugin reads ~/.ssh/config,
        -- so any Tailscale MagicDNS host you can `ssh <name>` to will work.
        network = { private = true },
      })
    end,
  },
}
