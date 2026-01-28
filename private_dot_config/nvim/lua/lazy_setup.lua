require("lazy").setup {
  {
    "AstroNvim/AstroNvim",
    version = "^4",
    import = "astronvim.plugins",
    opts = {
      mapleader = " ",
      maplocalleader = ",",
      icons_enabled = true,
      pin_plugins = nil,
    },
  },
  { import = "community" },
  { import = "plugins" },
  install = { colorscheme = { "tokyonight-night" } },
  ui = { backdrop = 100 },
  -- Limita operações git paralelas para evitar "Failed to spawn process"
  concurrency = 1, -- Forçar operações sequenciais
  git = {
    cmd = "git", -- Força usar git do PATH
    timeout = 300,
    url_format = "https://github.com/%s.git",
    cooldown = 500, -- Espera 500ms entre operações git
  },
  checker = {
    enabled = false, -- Desabilita checagem automática de updates
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
      },
    },
  },
}
