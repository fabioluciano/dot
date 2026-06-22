---@type LazySpec
return {
  {
    "nickjvandyke/opencode.nvim",
    -- opencode.nvim uses vim.g.opencode_opts instead of setup(), so we need a
    -- custom config function to avoid lazy.nvim calling the non-existent setup().
    -- See: https://mrcjkb.dev/posts/2023-08-22-setup.html
    config = function(_, opts)
      vim.g.opencode_opts = vim.tbl_deep_extend("force", vim.g.opencode_opts or {}, opts)
    end,
    opts = function(_, opts)
      -- Merge with existing opts from astrocommunity
      return vim.tbl_deep_extend("force", opts or {}, {
        events = {
          enabled = true,
          reload = true,      -- auto-reload buffers editados pelo opencode
          permissions = {
            enabled = true,
            idle_delay_ms = 1000,
            edits = { enabled = true },
          },
        },
        prompts = {
          ask         = { prompt = "",                                                                submit = true, ask = true },
          diagnostics = { prompt = "Explain @diagnostics",                                           submit = true },
          diff        = { prompt = "Review the following git diff for correctness: @diff",           submit = true },
          explain     = { prompt = "Explain @this and its context",                                  submit = true },
          review      = { prompt = "Review @this for correctness and readability",                   submit = true },
          document    = { prompt = "Add comments documenting @this",                                 submit = true },
          fix         = { prompt = "Fix @diagnostics",                                               submit = true },
          implement   = { prompt = "Implement @this",                                                submit = true },
          optimize    = { prompt = "Optimize @this for performance and readability",                 submit = true },
          test        = { prompt = "Add tests for @this",                                            submit = true },
          refactor    = { prompt = "Refactor @this to be more maintainable",                        submit = true },
          security    = { prompt = "Review @this for security vulnerabilities",                      submit = true },
          debug       = { prompt = "Add debug logging to @this",                     ask = true,     submit = false },
        },
      })
    end,
  },
}
