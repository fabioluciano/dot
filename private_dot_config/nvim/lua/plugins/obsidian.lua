-- ╭──────────────────────────────────────────────────────────╮
-- │                    Obsidian Plugin Config                 │
-- │              Configure Obsidian vault management          │
-- ╰──────────────────────────────────────────────────────────╯

---@type LazySpec
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "Obsidian",
        path = "~/Obsidian",
      },
    },
    notes_subdir = "notes",
    new_notes_location = "notes_subdir",
    completion = {
      nvim_cmp = true,
      min_chars = 1,
    },
    follow_url_func = function(url)
      vim.fn.jobstart { "open", url }
    end,
  },
}
