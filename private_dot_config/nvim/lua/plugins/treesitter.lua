-- ╭──────────────────────────────────────────────────────────╮
-- │                    Treesitter Configuration               │
-- ╰──────────────────────────────────────────────────────────╯

---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = true,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "lua",
        "vim",
        "dockerfile",
        "yaml",
        "json",
        "typst",
      })
    end,
  },
}
