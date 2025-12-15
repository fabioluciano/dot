-- ╭──────────────────────────────────────────────────────────╮
-- │                    AstroCommunity Plugins                 │
-- │              Community-maintained plugin configs          │
-- ╰──────────────────────────────────────────────────────────╯

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    Appearance                          │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.color.twilight-nvim" },
  { import = "astrocommunity.colorscheme.tokyonight-nvim" },
  { import = "astrocommunity.bars-and-lines.dropbar-nvim" },
  { import = "astrocommunity.bars-and-lines.vim-illuminate" },

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    Completion                          │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.completion.codeium-vim" },
  { import = "astrocommunity.completion.copilot-lua-cmp" },

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    Code Runner                         │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.code-runner.overseer-nvim" },
  { import = "astrocommunity.code-runner.sniprun" },

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    Debugging                           │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.debugging.nvim-dap-virtual-text" },
  { import = "astrocommunity.debugging.telescope-dap-nvim" },
  { import = "astrocommunity.debugging.persistent-breakpoints-nvim" },

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    Diagnostics                         │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.diagnostics.lsp_lines-nvim" },

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    Editing Support                     │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.editing-support.comment-box-nvim" },
  { import = "astrocommunity.editing-support.conform-nvim" },
  { import = "astrocommunity.editing-support.nvim-regexplainer" },
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.editing-support.ultimate-autopair-nvim" },
  { import = "astrocommunity.editing-support.vim-move" },
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  { import = "astrocommunity.editing-support.yanky-nvim" },
  { import = "astrocommunity.editing-support.refactoring-nvim" },
  { import = "astrocommunity.editing-support.zen-mode-nvim" },

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    File Explorer                       │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.file-explorer.telescope-file-browser-nvim" },
  { import = "astrocommunity.file-explorer.oil-nvim" },

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    Fuzzy Finder                        │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.fuzzy-finder.telescope-zoxide" },

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    Git                                 │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.git.blame-nvim" },
  { import = "astrocommunity.git.octo-nvim" },
  { import = "astrocommunity.git.neogit" },
  { import = "astrocommunity.git.diffview-nvim" },
  { import = "astrocommunity.git.git-blame-nvim" },

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    Indent                              │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.indent.mini-indentscope" },

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    LSP                                 │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.lsp.nvim-lint" },
  { import = "astrocommunity.lsp.lspsaga-nvim" },
  { import = "astrocommunity.lsp.garbage-day-nvim" },
  { import = "astrocommunity.lsp.inc-rename-nvim" },

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    Markdown & LaTeX                    │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.markdown-and-latex.glow-nvim" },
  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },
  { import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    Motion                              │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.motion.flash-nvim" },
  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.motion.mini-move" },
  { import = "astrocommunity.motion.hop-nvim" },

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    Language Packs                      │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.pack.angular" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.helm" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.php" },
  { import = "astrocommunity.pack.pkl" },
  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.sql" },
  { import = "astrocommunity.pack.terraform" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.typescript-all-in-one" },
  { import = "astrocommunity.pack.vue" },
  { import = "astrocommunity.pack.xml" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.chezmoi" },
  { import = "astrocommunity.pack.cmake" },
  { import = "astrocommunity.pack.nix" },

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    Project                             │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.project.project-nvim" },
  -- { import = "astrocommunity.project.nvim-spectre" }, -- DISABLED: module not found

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    Recipes                             │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.recipes.vscode" },
  { import = "astrocommunity.recipes.vscode-icons" },
  { import = "astrocommunity.recipes.neovide" },
  { import = "astrocommunity.recipes.telescope-lsp-mappings" },

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    Scrolling                           │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.scrolling.neoscroll-nvim" },
  { import = "astrocommunity.scrolling.mini-animate" },

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    Syntax                              │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.syntax.vim-easy-align" },
  { import = "astrocommunity.syntax.hlargs-nvim" },

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    Terminal Integration                │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.terminal-integration.vim-tmux-yank" },
  { import = "astrocommunity.terminal-integration.vim-tmux-navigator" },
  { import = "astrocommunity.terminal-integration.flatten-nvim" },

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    Utility                             │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.utility.noice-nvim" },
  { import = "astrocommunity.utility.telescope-live-grep-args-nvim" },

  -- ╭────────────────────────────────────────────────────────╮
  -- │                    Workflow                            │
  -- ╰────────────────────────────────────────────────────────╯
  { import = "astrocommunity.workflow.precognition-nvim" },

}
