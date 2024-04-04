vim.opt.wrap           = true
vim.opt.list           = true
vim.opt.spell          = true
vim.opt.spelllang      = { 'en_us' }
vim.opt.relativenumber = true
vim.opt.tabstop        = 2
vim.opt.shiftwidth     = 2
vim.opt.softtabstop    = 2
vim.opt.expandtab      = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")
-- set t_TI=^[[4?h
-- set t_TE=^[[4?l

lvim.transparent_window      = true
lvim.colorscheme             = "tokyonight-night"
lvim.builtin.nvimtree.active = false
lvim.format_on_save.enabled  = true


lvim.builtin.which_key.mappings["P"]      = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"]      = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
}
lvim.builtin.which_key.mappings['e']      = { "<cmd>NeoTreeFocusToggle<CR>", "Explorer" }

lvim.builtin.alpha.active                 = true
lvim.builtin.alpha.mode                   = "dashboard"
lvim.builtin.project.active               = true

lvim.lsp.installer.setup.ensure_installed = {
  "angularls",
  "ansiblels",
  "bashls",
  "cssls",
  "cssmodules_ls",
  "cucumber_language_server",
  "denols",
  "docker_compose_language_service",
  "dockerls",
  "emmet_ls",
  "eslint",
  "gradle_ls",
  "grammarly",
  "graphql",
  "helm_ls",
  "html",
  "jdtls",
  "jsonls",
  "lua_ls",
  "lemminx",
  "psalm",
  "pylsp",
  "pyright",
  "remark_ls",
  "rome",
  "rust_analyzer",
  "sqlls",
  "stylelint_lsp",
  "taplo",
  "terraformls",
  "tflint",
  "tsserver",
  "vuels",
  "volar",
  "vimls",
  "yamlls"
}

lvim.builtin.terminal.active              = true
lvim.builtin.terminal.direction           = "horizontal"


lvim.builtin.lualine.style              = "lvim"
lvim.builtin.lualine.sections.lualine_c = { "mode" }
lvim.builtin.luasnip.sources            = {
  friendly_snippets = true,
  ultisnips = true,
}


local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { name = "black" },
  {
    name = "prettier",
    args = { "--print-width", "100" },
    filetypes = { "typescript", "typescriptreact" },
  },
}

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { name = "flake8" },
}

local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup {
  {
    name = "proselint",
  },
}

-- keymappings
lvim.leader                    = "space"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"


lvim.plugins = {
  {
    "aserowy/tmux.nvim",
    config = function()
      return require("tmux").setup()
    end
  },
  {
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
        lsp = {
          signature = {
            enabled = false,
          },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = false,        -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = true,            -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true,        -- add a border to hover docs and signature help
        },
      })
    end
  },
  {
    'preservim/tagbar',
    event = 'BufEnter',
    config = function()
      vim.cmd("let g:tagbar_width = max([25, winwidth(0) / 5])")
    end
  },
  {
    'Exafunction/codeium.vim',
    event = 'BufEnter'
  },
  {
    "ellisonleao/glow.nvim",
    config = true,
    cmd = "Glow"
  },
  {
    "NoahTheDuke/vim-just",
    event = "BufEnter"
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "UIEnter" },
    config = function()
      require("hlchunk").setup({
        chunk = {
          chars = {
            horizontal_line = "┅",
            left_top = "┏",
            vertical_line = "┇",
            left_bottom = "┗",
            right_arrow = "┅",
          },
        },
        indent = {
          enable = true,
          use_treesitter = true,
        }
      })
    end
  },
  {
    "karb94/neoscroll.nvim",
    config = function()
      require('neoscroll').setup {}
    end
  },
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require('colorizer').setup()
    end
  },
  { "mg979/vim-visual-multi" },
  { "folke/tokyonight.nvim" },
  { "sheerun/vim-polyglot" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        event_handlers = {
          {
            event = "file_opened",
            handler = function(file_path)
              require("neo-tree").close_all()
            end
          },
        },
        close_if_last_window = true,
        window = {
          width = 30,
        },
        buffers = {
          follow_current_file = true,
        },
        filesystem = {
          follow_current_file = true,
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {
              "node_modules"
            },
            never_show = {
              ".DS_Store",
              "thumbs.db"
            },
          },
        },
      })
    end
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
      vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
    end,
  },
  {
    "nacro90/numb.nvim",
    event = "BufRead",
    config = function()
      require("numb").setup {
        show_numbers = true,
        show_cursorline = true,
        centered_peeking = true,
      }
    end,
  },
  {
    'wfxr/minimap.vim',
    build = "cargo install --locked code-minimap",
    cmd = { "Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight" },
    config = function()
      vim.cmd("let g:minimap_width = 10")
      vim.cmd("let g:minimap_auto_start = 1")
      vim.cmd("let g:minimap_auto_start_win_enter = 1")
    end,
  },
  {
    "kevinhwang91/rnvimr",
    cmd = "RnvimrToggle",
    config = function()
      vim.g.rnvimr_draw_border = 1
      vim.g.rnvimr_pick_enable = 1
      vim.g.rnvimr_bw_enable = 1
    end,
  },
  {
    "s1n7ax/nvim-window-picker",
    version = "1.*",
    config = function()
      require("window-picker").setup({
        autoselect_one = true,
        include_current = false,
        filter_rules = {
          bo = {
            filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix" },
            buftype = { "terminal" },
          },
        },
        other_win_hl_color = "#e35e4f",
      })
    end,
  },
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
  },
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      vim.g.gitblame_enabled = 1
    end,
  },
  {
    "mrjones2014/nvim-ts-rainbow",
  },
  {
    "rmagatti/goto-preview",
    config = function()
      require('goto-preview').setup {
        width = 120,
        height = 25,
        default_mappings = true,
        debug = false,
        opacity = nil,
      }
    end
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require "lsp_signature".on_attach() end,
  },
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require('symbols-outline').setup {
        auto_close = true,
      }
    end
  },
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require('neoscroll').setup({
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
          '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true,
        stop_eof = true,
        use_local_scrolloff = false,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = nil,
        pre_hook = nil,
        post_hook = nil,
      })
    end
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup {
        keywords = {
          FIX = {
            icon = " ",
            color = "error",
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
          },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
          TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
        gui_style = {
          fg = "NONE",
          bg = "BOLD",
        },
      }
    end,
  },
  {
    "itchyny/vim-cursorword",
    event = { "BufEnter", "BufNewFile" },
    config = function()
      vim.api.nvim_command("augroup user_plugin_cursorword")
      vim.api.nvim_command("autocmd!")
      vim.api.nvim_command("autocmd FileType NvimTree,lspsagafinder,dashboard,vista let b:cursorword = 0")
      vim.api.nvim_command("autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif")
      vim.api.nvim_command("autocmd InsertEnter * let b:cursorword = 0")
      vim.api.nvim_command("autocmd InsertLeave * let b:cursorword = 1")
      vim.api.nvim_command("augroup END")
    end
  },
  {
    "tpope/vim-surround",
  },
  {
    "mrjones2014/nvim-ts-rainbow",
  },
  {
    "NoahTheDuke/vim-just",
  },
  {
    "SirVer/ultisnips",
    dependencies = {
      "sebosp/vim-snippets-terraform",
    },
    config = function()
      vim.api.nvim_command("let g:UltiSnipsExpandTrigger='<tab>'")
      vim.api.nvim_command("let g:UltiSnipsJumpForwardTrigger='<c-b>'")
      vim.api.nvim_command("let g:UltiSnipsJumpBackwardTrigger='<c-z>'")
    end
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua",              -- optional
    },
    config = true
  }
}


local picker = require('window-picker')

vim.keymap.set("n", ",w", function()
  local picked_window_id = picker.pick_window({
    include_current_win = true
  }) or vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(picked_window_id)
end, { desc = "Pick a window" })

local function swap_windows()
  local window = picker.pick_window({
    include_current_win = false
  })
  local target_buffer = vim.fn.winbufnr(window)
  vim.api.nvim_win_set_buf(window, 0)
  vim.api.nvim_win_set_buf(0, target_buffer)
end

vim.keymap.set('n', ',W', swap_windows, { desc = 'Swap windows' })
