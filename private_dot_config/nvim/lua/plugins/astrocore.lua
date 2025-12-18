return {
  "AstroNvim/astrocore",
  opts = {
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 },
      autopairs = true,
      cmp = true,
      diagnostics_mode = 3,
      highlighturl = true,
      notifications = true,
    },
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    options = {
      opt = {
        updatetime = 100,
        conceallevel = 2,
        title = true,
        splitbelow = true,
        splitright = true,
        diffopt = vim.opt.diffopt + "vertical",
        linebreak = true,
        cursorline = true,
        breakindent = true,
        list = true,
        listchars = {
          space = "⋅",
          eol = "↲",
          tab = "󰌒",
          trail = "·",
          nbsp = "␣",
          extends = "…",
          precedes = "…",
        },
        relativenumber = false,
        number = true,
        spell = false, -- Disabled globally, enabled per filetype
        spelllang = { "en", "pt" },
        spelloptions = "camel", -- Check camelCase words separately
        signcolumn = "auto",
        wrap = true,
        tabstop = 2,
        -- Mouse support
        mouse = "a",
        mousescroll = "ver:3,hor:3",
        -- Scrolling
        scrolloff = 8,
        sidescrolloff = 8,
      },
      g = {},
    },
    mappings = {
      n = {
        ["<Leader>C"] = { desc = " Claude" },
      },
    },
    autocmds = {
      -- Enable spell only for text files (markdown, text, gitcommit, etc.)
      spell_text_files = {
        {
          event = "FileType",
          pattern = { "markdown", "text", "gitcommit", "plaintex", "tex", "rst", "asciidoc" },
          callback = function()
            vim.opt_local.spell = true
          end,
          desc = "Enable spell checking for text files",
        },
      },
      -- Enable spell only in comments for code files using Treesitter
      spell_comments = {
        {
          event = "FileType",
          pattern = {
            "lua", "python", "javascript", "typescript", "typescriptreact", "javascriptreact",
            "go", "rust", "c", "cpp", "java", "php", "ruby", "sh", "bash", "zsh", "yaml", "toml",
          },
          callback = function()
            vim.opt_local.spell = true
            -- Only check spelling in comments and strings via treesitter
            vim.opt_local.spelloptions:append("noplainbuffer")
          end,
          desc = "Enable spell checking only in comments for code files",
        },
      },
    },
  },
}
