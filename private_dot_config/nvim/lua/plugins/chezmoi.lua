---@type LazySpec
return {
  {
    "xvzc/chezmoi.nvim",
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          opts.autocmds = opts.autocmds or {}
          opts.autocmds.chezmoi = {
            {
              event = { "BufRead", "BufNewFile" },
              pattern = { os.getenv "HOME" .. "/.local/share/chezmoi/*" },
              callback = function(ev)
                local chezmoi = require "chezmoi"
                local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(ev.buf), ":t")
                local ignored = false

                for _, pattern in ipairs(chezmoi.config.edit.ignore_patterns or {}) do
                  if filename:match(pattern) then
                    ignored = true
                    break
                  end
                end

                if not ignored then
                  vim.schedule(function() require("chezmoi.commands.__edit").watch(ev.buf) end)
                end
              end,
            },
          }
        end,
      },
    },
  },
}