---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- Lua
        "lua-language-server",
        "stylua",

        -- Python
        "pyright",
        "ruff",
        "debugpy",

        -- Go
        "gopls",
        "gofumpt",
        "goimports",
        "golangci-lint",
        "delve",

        -- TypeScript/JavaScript
        "typescript-language-server",
        "prettier",
        "eslint-lsp",

        -- Angular
        "angular-language-server",

        -- Vue
        "vue-language-server",

        -- HTML/CSS
        "html-lsp",
        "css-lsp",
        "tailwindcss-language-server",

        -- JSON/YAML
        "json-lsp",
        "yaml-language-server",
        "yamllint",
        "yamlfmt",

        -- Bash
        "bash-language-server",
        "shfmt",

        -- Docker
        "dockerfile-language-server",
        "docker-compose-language-service",

        -- Terraform
        "terraform-ls",
        "tflint",

        -- Rust
        "rust-analyzer",

        -- PHP
        "intelephense",
        "phpactor",

        -- Java
        "jdtls",

        -- SQL
        "sqlls",

        -- XML
        "lemminx",

        -- TOML
        "taplo",

        -- Helm / Kubernetes
        "helm-ls",
        "kubeconform",

        -- Markdown
        "marksman",
        "markdownlint",

        -- MDX
        "mdx-analyzer",

        -- CMake
        "cmake-language-server",
        "cmakelint",

        -- General
        "tree-sitter-cli",
      },
    },
  },
}
