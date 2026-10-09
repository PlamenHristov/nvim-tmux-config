--[[
=====================================================================
Neovim Configuration - Enhanced for Rust Development
=====================================================================
Modular structure:
  - settings.lua     : Vim options and globals
  - keymap.lua       : All keymaps
  - autocommands.lua : Automatic behaviors
  - diagnostics.lua  : LSP diagnostic config
  - init.lua         : This file (lazy.nvim + plugins)
=====================================================================
--]]

-- Load settings first (includes leader key, must be before lazy)
require('settings')

-- [[ Install lazy.nvim plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Git signs
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
      },
    },
  },

  -- Diffview for git diffs and file history
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "[G]it [D]iff view" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "[G]it file [H]istory" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "[G]it repo [H]istory" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "[G]it diff [Q]uit" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { layout = "diff2_horizontal" },
        merge_tool = { layout = "diff3_mixed" },
      },
    },
  },

  -- Which-key for keybinding hints
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      local wk = require('which-key')
      wk.setup({
        delay = 300,
        icons = {
          breadcrumb = '»',
          separator = '➜',
          group = '+',
        },
      })
      -- Register key groups (works with both old and new API)
      pcall(function()
        wk.add({
          { '<leader>c', group = '[C]ode' },
          { '<leader>d', group = '[D]ocument' },
          { '<leader>f', group = '[F]ind (Telescope)' },
          { '<leader>r', group = '[R]ust/[R]ename' },
          { '<leader>G', group = '[G]o' },
          { '<leader>s', group = '[S]earch' },
          { '<leader>w', group = '[W]orkspace' },
          { '<leader>t', group = '[T]oggle' },
          { '<leader>g', group = '[G]it' },
          { '<leader>b', group = '[B]uffer' },
          { '<leader>x', group = 'Trouble/Diagnostics' },
        })
      end)
    end,
  },

  -- Fuzzy Finder (Telescope)
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')

      telescope.setup {
        defaults = {
          file_ignore_patterns = { 'node_modules', '.git/', 'target/', '__pycache__', '%.lock' },
          mappings = {
            i = {
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
              ['<C-x>'] = actions.delete_buffer,
              ['<C-s>'] = actions.select_horizontal,
              ['<C-v>'] = actions.select_vertical,
              ['<Esc>'] = actions.close,
            },
            n = {
              ['q'] = actions.close,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
            },
          },
          sorting_strategy = 'ascending',
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              prompt_position = 'top',
              preview_width = 0.55,
            },
            width = 0.87,
            height = 0.80,
          },
          path_display = { 'truncate' },
          prompt_prefix = '   ',
          selection_caret = '  ',
        },
        pickers = {
          find_files = {
            hidden = true,
            previewer = false,
            layout_config = { width = 0.6, height = 0.6 },
          },
          buffers = {
            previewer = false,
            layout_config = { width = 0.6, height = 0.5 },
            sort_mru = true,
          },
          git_files = {
            previewer = false,
            layout_config = { width = 0.6, height = 0.6 },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },
        },
      }

      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'

      -- Search keymaps
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Git keymaps
      vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[G]it [C]ommits' })
      vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus' })
      vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = '[G]it [B]ranches' })
      vim.keymap.set('n', '<leader>gp', '<cmd>!git pull<CR><cmd>checktime<CR>', { desc = '[G]it [P]ull' })
      vim.keymap.set('n', '<leader>!', ':TermExec cmd=""<Left>', { desc = 'Run command in terminal' })

      -- Buffer keymaps
      vim.keymap.set('n', '<leader>bb', builtin.buffers, { desc = '[B]uffer list' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })

      -- Quick access shortcuts (common keymaps)
      vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Find files' })

      -- Alternative keymaps (ff/fg style from dotfiles)
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind [B]uffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = '[F]ind [R]ecent' })
      vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = '[F]ind [C]ommands' })
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind [W]ord under cursor' })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
    end,
  },

  -- LSP Configuration (Neovim 0.11+ native API)
  {
    'williamboman/mason.nvim',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      {
          'j-hui/fidget.nvim',
          opts = {
            notification = {
              window = {
                winblend = 0,
                -- Avoid nvim-tree file explorer
                avoid = { 'NvimTree' },
              },
            },
          },
        },
    },
    config = function()
      -- Setup Mason first
      require('mason').setup()
      require('mason-tool-installer').setup {
        ensure_installed = {
          'stylua',
          'rust-analyzer',
          'lua-language-server',
          'gopls',
          'goimports',
          'gofumpt',
          'golangci-lint',
          'vtsls',
          'nomicfoundation-solidity-language-server',
          'prettierd',
        },
      }
      require('mason-lspconfig').setup()
    end,
  },

  -- LSP keymaps and settings (using native vim.lsp.config)
  {
    'hrsh7th/cmp-nvim-lsp',
    config = function()
      -- LSP Attach keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Inlay hints toggle
          if vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle Inlay [H]ints')
            vim.lsp.inlay_hint.enable(true)
          end

          local client = vim.lsp.get_clients({ id = event.data.client_id })[1]
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- Get capabilities from cmp_nvim_lsp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Configure LSP servers using Neovim 0.11+ native API
      vim.lsp.config.rust_analyzer = {
        cmd = { 'rust-analyzer' },
        filetypes = { 'rust' },
        root_markers = { 'Cargo.toml', 'rust-project.json' },
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            checkOnSave = true,
            check = {
              command = 'clippy',
              extraArgs = { '--all', '--', '-W', 'clippy::all' },
            },
            cargo = {
              allFeatures = false,
              loadOutDirsFromCheck = true,
            },
            procMacro = { enable = true },
            diagnostics = {
              enable = true,
              experimental = { enable = true },
            },
            inlayHints = {
              enable = true,
              bindingModeHints = { enable = true },
              chainingHints = { enable = true },
              closingBraceHints = { enable = true, minLines = 25 },
              closureReturnTypeHints = { enable = 'with_block' },
              lifetimeElisionHints = { enable = 'skip_trivial', useParameterNames = true },
              maxLength = 25,
              parameterHints = { enable = true },
              reborrowHints = { enable = 'mutable' },
              renderColons = true,
              typeHints = {
                enable = true,
                hideClosureInitialization = false,
                hideNamedConstructor = false,
              },
            },
            lens = {
              enable = true,
              references = {
                adt = { enable = true },
                enumVariant = { enable = true },
                method = { enable = true },
                trait = { enable = true },
              },
              implementations = { enable = true },
            },
            hover = {
              actions = {
                references = { enable = true },
                run = { enable = true },
                debug = { enable = true },
              },
            },
            semanticHighlighting = {
              operator = { specialization = { enable = true } },
              punctuation = {
                enable = true,
                separate = { macro = { bang = true } },
                specialization = { enable = true },
              },
              strings = { enable = true },
            },
          },
        },
      }

      vim.lsp.config.gopls = {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        root_markers = { 'go.work', 'go.mod', '.git' },
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              shadow = true,
              nilness = true,
              unusedwrite = true,
              useany = true,
              fieldalignment = false,
            },
            staticcheck = true,
            gofumpt = true,
            usePlaceholders = true,
            completeUnimported = true,
            directoryFilters = { '-.git', '-node_modules', '-vendor' },
            semanticTokens = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
          },
        },
      }

      vim.lsp.config.lua_ls = {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
            completion = { callSnippet = 'Replace' },
          },
        },
      }

      vim.lsp.config.vtsls = {
        cmd = { 'vtsls', '--stdio' },
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'typescript.tsx' },
        root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = { enabled = 'literals' },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
          javascript = {
            inlayHints = {
              parameterNames = { enabled = 'literals' },
              variableTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
            },
          },
        },
      }

      vim.lsp.config.solidity = {
        cmd = { 'nomicfoundation-solidity-language-server', '--stdio' },
        filetypes = { 'solidity' },
        root_markers = { 'foundry.toml', 'hardhat.config.js', 'hardhat.config.ts', 'remappings.txt', '.git' },
        capabilities = capabilities,
      }

      -- Enable the LSP servers
      vim.lsp.enable('rust_analyzer')
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('gopls')
      vim.lsp.enable('vtsls')
      vim.lsp.enable('solidity')
    end,
  },

  -- Autoformat
  {
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[C]ode [F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and 'never' or 'fallback'
        return {
          timeout_ms = 500,
          lsp_format = lsp_format,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        rust = { 'rustfmt' },
        go = { 'goimports', 'gofumpt' },
        javascript = { 'prettierd' },
        javascriptreact = { 'prettierd' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        json = { 'prettierd' },
      },
    },
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'onsails/lspkind.nvim',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local lspkind = require 'lspkind'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'crates' },
        }, {
          { name = 'buffer' },
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
            ellipsis_char = '...',
            menu = {
              nvim_lsp = '[LSP]',
              luasnip = '[Snip]',
              buffer = '[Buf]',
              path = '[Path]',
              crates = '[Crate]',
            },
          }),
        },
      }
    end,
  },

  -- Colour scheme. Exactly one of these is active; the specs live in lua/themes/.
  -- require 'themes.catppuccin',
  require 'themes.intellij-darcula',

  -- Todo comments highlighting
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -- Mini.nvim collection
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      -- Neovim 0.12 bundles parsers and queries for these languages. Remove the
      -- plugin's copies so the bundled pair is used together; an old plugin
      -- parser against the bundled queries raises query errors.
      local plugin_dir = vim.fn.stdpath('data') .. '/lazy/nvim-treesitter'
      for _, lang in ipairs({ 'c', 'lua', 'markdown', 'markdown_inline', 'vim', 'vimdoc', 'query' }) do
        local lang_dir = plugin_dir .. '/queries/' .. lang
        if vim.uv.fs_stat(lang_dir) then
          vim.fn.delete(lang_dir, 'rf')
        end
        local parser = plugin_dir .. '/parser/' .. lang .. '.so'
        if vim.uv.fs_stat(parser) then
          vim.fn.delete(parser)
        end
      end

      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'bash', 'html', 'luadoc',
          'rust', 'python', 'javascript', 'typescript',
          'toml', 'json', 'yaml', 'tsx',
          'go', 'gomod', 'gosum', 'gowork',
          'solidity',
        },
        auto_install = vim.fn.executable 'tree-sitter' == 1,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })
    end,
  },

  -- Crates.nvim for Cargo.toml
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('crates').setup {
        popup = {
          autofocus = true,
          border = 'rounded',
        },
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
      }
    end,
  },

  -- File explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup {
        view = {
          width = 30,
          side = 'left',  -- Open on the left side
        },
        renderer = {
          group_empty = true,
          highlight_git = true,
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        filters = {
          dotfiles = false,
        },
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,      -- Auto-expand to current file
          update_root = true, -- Update root dir to file's parent
        },
        actions = {
          open_file = {
            quit_on_open = false,  -- Keep tree open after opening file
          },
        },
      }
      vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
      vim.keymap.set('n', '<leader>o', ':NvimTreeFocus<CR>', { desc = 'Focus file explorer' })
      vim.keymap.set('n', '<leader>E', ':NvimTreeFindFileToggle<CR>', { desc = 'Find file in explorer' })
    end,
  },

  -- Terminal
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        size = 20,
        open_mapping = [[<c-\>]],
        direction = 'float',
        float_opts = {
          border = 'curved',
        },
      }

      -- Cargo terminals
      local Terminal = require('toggleterm.terminal').Terminal
      local cargo_run = Terminal:new { cmd = 'cargo run', hidden = true, direction = 'float' }
      local cargo_test = Terminal:new { cmd = 'cargo test', hidden = true, direction = 'float' }
      local cargo_build = Terminal:new { cmd = 'cargo build', hidden = true, direction = 'float' }

      vim.keymap.set('n', '<leader>rr', function() cargo_run:toggle() end, { desc = '[R]ust [R]un' })
      vim.keymap.set('n', '<leader>rt', function() cargo_test:toggle() end, { desc = '[R]ust [T]est' })
      vim.keymap.set('n', '<leader>rb', function() cargo_build:toggle() end, { desc = '[R]ust [B]uild' })

      -- Go terminals
      local go_run = Terminal:new { cmd = 'go run .', hidden = true, direction = 'float' }
      local go_test = Terminal:new { cmd = 'go test ./...', hidden = true, direction = 'float' }
      local go_build = Terminal:new { cmd = 'go build ./...', hidden = true, direction = 'float' }

      vim.keymap.set('n', '<leader>Gr', function() go_run:toggle() end, { desc = '[G]o [R]un' })
      vim.keymap.set('n', '<leader>Gt', function() go_test:toggle() end, { desc = '[G]o [T]est' })
      vim.keymap.set('n', '<leader>Gb', function() go_build:toggle() end, { desc = '[G]o [B]uild' })
    end,
  },

  -- Indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      require('ibl').setup {
        indent = {
          char = '│',
        },
        scope = {
          enabled = true,
          show_start = false,
          show_end = false,
        },
      }
    end,
  },

  -- Auto pairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup {
        check_ts = true,
      }
    end,
  },

  -- Pulls in everything under lua/custom/plugins/ (delete this line to remove)
  { import = 'custom.plugins' },

}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Load other modules (after plugins so they can use plugin functions)
require('keymap')
require('autocommands')
require('diagnostics')

-- vim: ts=2 sts=2 sw=2 et
