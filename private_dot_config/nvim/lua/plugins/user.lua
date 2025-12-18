-- ╭──────────────────────────────────────────────────────────╮
-- │                    User Plugins                           │
-- │              Custom plugins not in AstroCommunity         │
-- ╰──────────────────────────────────────────────────────────╯

return {
  -- Justfile syntax
  { "NoahTheDuke/vim-just", ft = "just" },

  -- Discord presence
  {
    "andweeb/presence.nvim",
    event = "VeryLazy",
    opts = {
      neovim_image_text = "The One True Text Editor",
      main_image = "neovim",
      debounce_timeout = 10,
      enable_line_number = false,
      buttons = true,
    },
  },

  -- LSP signature help
  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    opts = {
      bind = true,
      handler_opts = { border = "rounded" },
      floating_window = true,
      hint_enable = true,
      hint_prefix = "󰏫 ",
      hi_parameter = "LspSignatureActiveParameter",
    },
  },

  -- LuaSnip configuration
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts)
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
      luasnip.filetype_extend("typescript", { "typescriptreact" })
      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
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
      filetypes = { "*" },
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
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
      { "zK", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Peek fold" },
    },
  },

  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" } },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load { last = true } end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Session" },
    },
  },

  -- Smooth cursor
  {
    "gen740/SmoothCursor.nvim",
    event = "VeryLazy",
    opts = {
      type = "default",
      fancy = {
        enable = true,
        head = { cursor = "▷", texthl = "SmoothCursor", linehl = nil },
      },
      speed = 25,
      intervals = 35,
    },
  },

  -- Claude Code integration
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>C", group = "Claude" },
      { "<leader>Cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<leader>Cs", "<cmd>ClaudeCodeSend<cr>", desc = "Send to Claude", mode = { "n", "v" } },
    },
    opts = {
      window = {
        position = "float", -- Janela flutuante
        enter_insert = true,
      },
    },
  },
}
