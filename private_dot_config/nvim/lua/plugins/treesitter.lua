-- ╭──────────────────────────────────────────────────────────╮
-- │                    Treesitter Configuration               │
-- ╰──────────────────────────────────────────────────────────╯

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "lua",
      "vim",
      "dockerfile",
      "yaml",
      "json",
      "markdown",
      "markdown_inline",
    })
    -- Remove jsonc from ensure_installed if present (download issues)
    if opts.ensure_installed then
      for i, lang in ipairs(opts.ensure_installed) do
        if lang == "jsonc" then
          table.remove(opts.ensure_installed, i)
          break
        end
      end
    end
  end,
}
