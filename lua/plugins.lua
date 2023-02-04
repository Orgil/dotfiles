local map = require("utils").map
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		branch = "main",
		lazy = true, -- make sure we load this during startup if it is your main colorscheme
	},
	{
		"folke/tokyonight.nvim",
		name = "tokyonight",
		lazy = true, -- make sure we load this during startup if it is your main colorscheme
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
		opts = {
			options = {
				styles = {
					comments = "italic",
					keywords = "italic",
				},
			},
		},
		config = function(_, opts)
			-- load the colorscheme here
			require("nightfox").setup(opts)

			vim.cmd([[colorscheme duskfox]])
		end,
	},
	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		after = "mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{ "j-hui/fidget.nvim", config = true },
			"folke/neodev.nvim",
		},
	},
	{ "folke/neoconf.nvim", cmd = "Neoconf" },
	{ "numToStr/Comment.nvim", config = true },
	{ "NvChad/nvim-colorizer.lua", config = true },
	{ "nacro90/numb.nvim", config = true },
	{ "chaoren/vim-wordmotion" },
	{ "tpope/vim-surround" },
	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	},
	{ "windwp/nvim-autopairs", config = true },
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			indent_lines = false,
			padding = 1,
			auto_close = true,
		},
		config = function(_, opts)
			require("trouble").setup(opts)
			map("n", "<F2>", ":TodoTrouble<cr>")
			map("n", "<F3>", ":TroubleToggle workspace_diagnostics<cr>")
		end,
	},
	{
		"folke/zen-mode.nvim",
		opts = {
			window = { width = 160 },
		},
		config = function(_, opts)
			require("zen-mode").setup(opts)
			map("n", "<leader>o", ":ZenMode<cr>")
		end,
	},
	{
		"nanozuki/tabby.nvim",
		config = function()
			local theme = {
				fill = "TabLineFill",
				-- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
				head = "TabLine",
				current_tab = "TabLineSel",
				tab = "TabLine",
				win = "TabLine",
				tail = "TabLine",
			}
			require("tabby.tabline").set(function(line)
				return {
					{
						{ "  ", hl = theme.head },
						line.sep("", theme.head, theme.fill),
					},
					line.tabs().foreach(function(tab)
						local hl = tab.is_current() and theme.current_tab or theme.tab
						return {
							line.sep("", hl, theme.fill),
							tab.is_current() and "" or "",
							tab.number(),
							line.sep("", hl, theme.fill),
							hl = hl,
							margin = " ",
						}
					end),
					{
						line.sep("", theme.fill, theme.fill),
						line.sep("", theme.fill, theme.fill),
					},
					line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
						if win.is_current() then
							return {
								line.sep("", theme.win, theme.fill),
								win.buf_name(),
								line.sep("", theme.win, theme.fill),
								hl = theme.win,
								margin = " ",
							}
						end
					end),
					line.spacer(),
					{
						line.sep("", theme.tail, theme.fill),
						{ "  ", hl = theme.tail },
					},
					hl = theme.fill,
				}
			end)
		end,
	},
	{ "lewis6991/gitsigns.nvim", config = true },
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function(_, opts)
			require("toggleterm").setup(opts)

			function _G.set_terminal_keymaps()
				local options = { buffer = 0 }
				vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], options)
				vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], options)
				vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], options)
				vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], options)
				vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], options)
				vim.keymap.set("t", "<leader>ft", [[<Cmd>ToggleTerm<CR>]], options)
			end

			-- if you only want these mappings for toggle term use term://*toggleterm#* instead
			vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
			map("n", "<leader>ft", ":ToggleTerm size=20 direction=horizontal<cr>")
		end,
	},
	{
		"mbbill/undotree",
		config = function()
			vim.g.undotree_WindowLayout = 3
			vim.g.undotree_SplitWidth = 60
			vim.g.undotree_DiffpanelHeight = 20
			vim.g.undotree_DiffAutoOpen = 0
			vim.g.undotree_SetFocusWhenToggle = 1
			vim.g.undotree_TreeVertShape = "│"
			vim.g.undotree_TreeSplitShape = "╱"
			vim.g.undotree_TreeReturnShape = "╲"
			vim.g.undotree_TreeNodeShape = ""
			map("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	},
	{
		"stevearc/dressing.nvim",
		config = function()
			require("dressing").setup()
		end,
	},
}
