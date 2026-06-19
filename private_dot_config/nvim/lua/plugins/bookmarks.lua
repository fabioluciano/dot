local bookmarks_file = vim.fn.stdpath("data") .. "/bookmarks.json"

local function load_bookmarks()
  local file = io.open(bookmarks_file, "r")
  if not file then return {} end
  local content = file:read("*a")
  file:close()
  return vim.fn.json_decode(content) or {}
end

local function save_bookmarks(bookmarks)
  local file = io.open(bookmarks_file, "w")
  if not file then return end
  file:write(vim.fn.json_encode(bookmarks))
  file:close()
end

local function add_bookmark()
  local cwd = vim.fn.getcwd()
  local bookmarks = load_bookmarks()
  
  for _, b in ipairs(bookmarks) do
    if b == cwd then
      vim.notify("Já está nos bookmarks: " .. cwd, vim.log.levels.WARN)
      return
    end
  end
  
  table.insert(bookmarks, cwd)
  save_bookmarks(bookmarks)
  vim.notify("Adicionado aos bookmarks: " .. cwd, vim.log.levels.INFO)
end

local function remove_bookmark()
  local cwd = vim.fn.getcwd()
  local bookmarks = load_bookmarks()
  local new_bookmarks = {}
  
  for _, b in ipairs(bookmarks) do
    if b ~= cwd then
      table.insert(new_bookmarks, b)
    end
  end
  
  save_bookmarks(new_bookmarks)
  vim.notify("Removido dos bookmarks: " .. cwd, vim.log.levels.INFO)
end

return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        function()
          local bookmarks = load_bookmarks()
          if #bookmarks == 0 then return nil end
          
          local items = {}
          for _, dir in ipairs(bookmarks) do
            table.insert(items, {
              icon = " ",
              desc = vim.fn.fnamemodify(dir, ":~"),
              action = function()
                vim.cmd("cd " .. dir)
                require("snacks").explorer()
              end,
            })
          end
          
          return {
            title = "Bookmarks",
            padding = 1,
            items = items,
          }
        end,
        { section = "startup" },
      },
    },
  },
  keys = {
    { "<leader>Ba", add_bookmark, desc = "Add Bookmark" },
    { "<leader>Br", remove_bookmark, desc = "Remove Bookmark" },
  },
}
