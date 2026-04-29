---@type LazySpec
return {
  -- Full tmux integration (navigation, resize, copy mode)
  {
    "aserowy/tmux.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Neo-tree file explorer customization
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
        },
        icon = {
          folder_closed = "\u{e5ff}",
          folder_open = "\u{e5fe}",
          folder_empty = "\u{f115}",
          folder_empty_open = "\u{f115}",
        },
        git_status = {
          symbols = {
            added = "\u{f457}",
            modified = "\u{f459}",
            deleted = "\u{f458}",
            renamed = "\u{f45a}",
            untracked = "\u{f128}",
            ignored = "\u{f474}",
            unstaged = "\u{f06a}",
            staged = "\u{f055}",
            conflict = "\u{eb37}",
          },
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        use_libuv_file_watcher = true,
        group_empty_dirs = true,
        follow_current_file = {
          enabled = false,
        },
      },
    },
  },

  -- Better quick fix list
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      preview = {
        winblend = 0,
      },
    },
  },

  -- Better marks
  {
    "chentoast/marks.nvim",
    event = "BufReadPost",
    opts = {
      default_mappings = true,
      signs = true,
      mappings = {},
    },
  },

  -- Undo tree visualization
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>U", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
    },
  },

  -- Color highlighter
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      filetypes = {
        "css",
        "scss",
        "sass",
        "less",
        "html",
        "vue",
        "svelte",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "lua",
        "conf",
        "toml",
        "yaml",
      },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        css = true,
        css_fn = true,
        mode = "virtualtext",
        virtualtext = "■",
        tailwind = true,
      },
    },
  },

  -- Better fold
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    opts = {
      provider_selector = function() return { "treesitter", "indent" } end,
    },
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    keys = {
      {
        "zR",
        function() require("ufo").openAllFolds() end,
        desc = "Open all folds",
      },
      {
        "zM",
        function() require("ufo").closeAllFolds() end,
        desc = "Close all folds",
      },
      {
        "zK",
        function() require("ufo").peekFoldedLinesUnderCursor() end,
        desc = "Peek fold",
      },
    },
  },

  -- Fix nvim-notify E937 on Neovim 0.12+
  {
    "rcarriga/nvim-notify",
    opts = { stages = "static" },
  },
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
