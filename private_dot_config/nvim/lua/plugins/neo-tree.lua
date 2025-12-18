-- ╭──────────────────────────────────────────────────────────╮
-- │                    Neo-tree Configuration                │
-- │              File explorer with proper icons             │
-- ╰──────────────────────────────────────────────────────────╯

-- Nerd Font icons:
-- Folder closed: U+E5FF (nf-custom-folder)
-- Folder open: U+E5FE (nf-custom-folder_open)
-- Folder empty: U+F115 (nf-fa-folder_open_o)

---@type LazySpec
return {
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
    },
  },
}
