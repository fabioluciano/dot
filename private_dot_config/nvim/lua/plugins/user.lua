-- ╭──────────────────────────────────────────────────────────╮
-- │                    User Plugins                           │
-- │              Custom plugins not in AstroCommunity         │
-- ╰──────────────────────────────────────────────────────────╯

return {
	-- Better quick fix list
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		opts = {
			preview = {
				winblend = 0,
			},
		},
	},

	-- Better marks
	{
		"chentoast/marks.nvim",
		event = "BufReadPost",
		opts = {
			default_mappings = true,
			signs = true,
			mappings = {},
		},
	},

	-- Undo tree visualization
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		keys = {
			{ "<leader>U", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
		},
	},

	-- Color highlighter
	{
		"NvChad/nvim-colorizer.lua",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			filetypes = {
				"css", "scss", "sass", "less",
				"html", "vue", "svelte",
				"javascript", "javascriptreact", "typescript", "typescriptreact",
				"lua", "conf", "toml", "yaml",
			},
			user_default_options = {
				RGB = true,
				RRGGBB = true,
				names = false,
				RRGGBBAA = true,
				css = true,
				css_fn = true,
				mode = "virtualtext",
				virtualtext = "■",
				tailwind = true,
			},
		},
	},

	-- Better fold
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "BufReadPost",
		opts = {
			provider_selector = function()
				return { "treesitter", "indent" }
			end,
		},
		init = function()
			vim.o.foldcolumn = "1"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
		end,
		keys = {
			{
				"zR",
				function()
					require("ufo").openAllFolds()
				end,
				desc = "Open all folds",
			},
			{
				"zM",
				function()
					require("ufo").closeAllFolds()
				end,
				desc = "Close all folds",
			},
			{
				"zK",
				function()
					require("ufo").peekFoldedLinesUnderCursor()
				end,
				desc = "Peek fold",
			},
		},
	},
}
