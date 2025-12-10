-- ╭──────────────────────────────────────────────────────────╮
-- │                    Polish Configuration                   │
-- │              Final setup after all plugins loaded         │
-- ╰──────────────────────────────────────────────────────────╯

-- Custom filetypes
vim.filetype.add {
  extension = {
    zsh = "sh",
    sh = "sh",
    tmpl = "gotmpl",
    conf = "conf",
    env = "sh",
  },
  filename = {
    [".zshrc"] = "sh",
    [".zshenv"] = "sh",
    [".zprofile"] = "sh",
    [".bashrc"] = "sh",
    [".bash_profile"] = "sh",
    ["Brewfile"] = "ruby",
    ["Justfile"] = "just",
    ["justfile"] = "just",
    [".envrc"] = "sh",
    [".env"] = "sh",
    [".env.local"] = "sh",
    [".env.example"] = "sh",
    ["Dockerfile"] = "dockerfile",
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
  },
  pattern = {
    ["%.env%.[%w_.-]+"] = "sh",
    ["Dockerfile.*"] = "dockerfile",
    [".*%.tmpl"] = "gotmpl",
    [".*%.gotmpl"] = "gotmpl",
  },
}

-- Diagnostic signs with icons
local signs = {
  Error = "",
  Warn = "",
  Hint = "󰌵",
  Info = "󰋼",
}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Transparent background for tokyonight
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "tokyonight*",
  callback = function()
    local groups = {
      "Normal",
      "NormalNC",
      "NormalFloat",
      "FloatBorder",
      "SignColumn",
      "EndOfBuffer",
      "NeoTreeNormal",
      "NeoTreeNormalNC",
      "TelescopeNormal",
      "TelescopeBorder",
      "WhichKeyFloat",
    }
    for _, group in ipairs(groups) do
      vim.api.nvim_set_hl(0, group, { bg = "NONE" })
    end
  end,
})

-- Apply transparency on startup if tokyonight is active
vim.defer_fn(function()
  if vim.g.colors_name and vim.g.colors_name:match "^tokyonight" then
    vim.cmd "doautocmd ColorScheme " .. vim.g.colors_name
  end
end, 100)

-- ╭──────────────────────────────────────────────────────────╮
-- │                    Spellcheck Setup                       │
-- │              Download spell files if missing              │
-- ╰──────────────────────────────────────────────────────────╯

-- Auto-download spell files for pt_BR and en_US
local spell_dir = vim.fn.stdpath "data" .. "/site/spell"

-- Create spell directory if it doesn't exist
vim.fn.mkdir(spell_dir, "p")

-- Function to download spell file if missing
local function ensure_spell_file(lang)
  local spell_file = spell_dir .. "/" .. lang .. ".utf-8.spl"
  if vim.fn.filereadable(spell_file) == 0 then
    vim.notify("Downloading spell file for " .. lang .. "...", vim.log.levels.INFO)
    -- Neovim will auto-download when spell is enabled
    vim.opt.spelllang = { lang }
  end
end

-- Ensure spell files exist
vim.defer_fn(function()
  ensure_spell_file "en"
  ensure_spell_file "pt"
  -- Set both languages
  vim.opt.spelllang = { "en", "pt" }
end, 500)

-- Disable semantic tokens for performance (optional)
-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if client then client.server_capabilities.semanticTokensProvider = nil end
--   end,
-- })
