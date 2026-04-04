local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

---@type LazySpec
return {
  {
    "Saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}
      opts.completion = opts.completion or {}
      opts.completion.list = opts.completion.list or {}
      opts.completion.list.selection = opts.completion.list.selection or {}
      opts.completion.documentation = opts.completion.documentation or {}

      opts.keymap["<Tab>"] = {
        function()
          if vim.g.ai_accept then return vim.g.ai_accept() end
        end,
        "select_next",
        "snippet_forward",
        function(cmp)
          if has_words_before() or vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
        end,
        "fallback",
      }
      opts.keymap["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" }
      opts.keymap["<C-y>"] = { "accept", "fallback" }

      opts.completion.list.selection.auto_insert = false
      opts.completion.documentation.auto_show_delay_ms = 150
    end,
  },
}