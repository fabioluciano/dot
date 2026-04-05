return {
  {
    "williamboman/mason.nvim",
    version = "^1",
    opts = {
      ensure_installed = {
        "prettier",
        "stylua",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    version = "^1",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "lua_ls",
        "tinymist",           -- Typst language server
      })
      -- Fix astrocommunity.pack.docker using invalid lspconfig name
      for i, name in ipairs(opts.ensure_installed) do
        if name == "docker-language-server" then
          opts.ensure_installed[i] = "dockerls"
          break
        end
      end
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    enabled = false,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "python",
      })
    end,
  },
}
