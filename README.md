# nvim-tmux-config

Neovim and tmux configuration.

```
nvim/    ~/.config/nvim   (kickstart.nvim base + custom lua/)
tmux/    ~/.config/tmux   (gpakosz/.tmux base, tmux.conf)
```

## Install

```sh
git clone <this-repo> ~/src/nvim-tmux-config
ln -s ~/src/nvim-tmux-config/nvim  ~/.config/nvim
mkdir -p ~/.config/tmux
ln -s ~/src/nvim-tmux-config/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -s ~/.config/tmux/tmux.conf ~/.tmux.conf
```

tmux plugins are managed by TPM:

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then `prefix + I` inside tmux to install plugins. Neovim plugins install on
first launch via lazy.nvim; `lazy-lock.json` pins the versions.

## Layout

- `nvim/init.lua` - kickstart base, plugin specs
- `nvim/lua/settings.lua` - options, leader keys
- `nvim/lua/keymap.lua` - keymaps
- `nvim/lua/autocommands.lua` - autocommands
- `nvim/lua/diagnostics.lua` - diagnostic config
- `nvim/lua/custom/plugins/` - personal plugin additions (incl. distant.nvim for remote dev)
- `nvim/lua/kickstart/plugins/` - optional kickstart modules
- `tmux/tmux.conf` - tmux settings, bindings, TPM plugin list

## Notes

No credentials, hostnames or machine-specific paths are committed. distant.nvim
reads hosts from `~/.ssh/config` at runtime, which is not part of this repo.
