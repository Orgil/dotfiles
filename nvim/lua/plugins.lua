local map = require("utils").map
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		branch = "main",
		lazy = false,
		priority = 1000, -- load before the other start plugins
		opts = {
			flavour = "mocha", -- latte | frappe | macchiato | mocha
			integrations = {
				blink_cmp = true,
				flash = true,
				gitsigns = true,
				mini = { enabled = true },
				noice = true,
				nvimtree = true,
				snacks = { enabled = true },
				treesitter_context = true,
				which_key = true,
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"folke/tokyonight.nvim",
		name = "tokyonight",
		lazy = true, -- make sure we load this during startup if it is your main colorscheme
	},
	{ "folke/persistence.nvim", event = "BufReadPre", opts = {} },
	{
		"EdenEast/nightfox.nvim",
		lazy = true, -- :colorscheme duskfox (set up in config below when loaded)
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
		end,
	},
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		after = "mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{ "j-hui/fidget.nvim", config = true },
		},
	},
	{ "folke/lazydev.nvim", ft = "lua" },
	{ "folke/neoconf.nvim", cmd = "Neoconf" },
	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gc", mode = { "n", "x" }, desc = "Comment (line/motion)" },
			{ "gb", mode = { "n", "x" }, desc = "Comment (block)" },
		},
		config = true,
	},
	{ "NvChad/nvim-colorizer.lua", event = { "BufReadPre", "BufNewFile" }, config = true },
	{ "nacro90/numb.nvim", event = "VeryLazy", config = true },
	{ "chaoren/vim-wordmotion" },
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
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
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				disable_filetype = { "snacks_picker_input", "vim" },
				enable_check_bracket_line = false,
				check_ts = true,
				ts_config = {
					lua = { "string" }, -- it will not add a pair on that treesitter node
					javascript = { "template_string" },
					java = false, -- don't check treesitter on java
				},
				break_line_filetype = nil, -- enable this rule for all filetypes
				pairs_map = {
					["'"] = "'",
					['"'] = '"',
					["("] = ")",
					["["] = "]",
					["{"] = "}",
					["`"] = "`",
				},
				html_break_line_filetype = {
					"html",
					"vue",
					"typescriptreact",
					"svelte",
					"javascriptreact",
				},
				ignored_next_char = "[%w%.%+%-%=%/%,]",
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			enable_close_on_slash = false,
		},
		config = true,
	},
	{ "tpope/vim-repeat" },
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		keys = { { "<F3>", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" } },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			indent_guides = false,
			auto_close = true,
		},
	},
	-- {
	-- 	"gbprod/yanky.nvim",
	-- 	config = function()
	-- 		require("yanky").setup()
	-- 		vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
	-- 		vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
	-- 		vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
	-- 		vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
	-- 		vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
	-- 		vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
	-- 	end,
	-- },
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		keys = { { "<leader>o", "<cmd>ZenMode<cr>", desc = "Zen mode" } },
		opts = {
			window = { width = 160 },
		},
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
			end, {
				buf_name = {
					mode = "relative",
				},
			})
		end,
	},
	{ "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" }, config = true },
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = "ToggleTerm",
		keys = { { "<leader>ft", "<cmd>ToggleTerm size=20 direction=float<cr>", desc = "Terminal" } },
		opts = {
			direction = "float",
			border = "curved",
			width = function()
				return vim.o.columns * 0.4
			end,
			winblend = 3,
		},
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
		end,
	},
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undotree" } },
		init = function()
			vim.g.undotree_WindowLayout = 3
			vim.g.undotree_SplitWidth = 60
			vim.g.undotree_DiffpanelHeight = 20
			vim.g.undotree_DiffAutoOpen = 0
			vim.g.undotree_SetFocusWhenToggle = 1
			vim.g.undotree_TreeVertShape = "│"
			vim.g.undotree_TreeSplitShape = "╱"
			vim.g.undotree_TreeReturnShape = "╲"
			vim.g.undotree_TreeNodeShape = ""
		end,
	},
	-- {
	--   "luukvbaal/statuscol.nvim",
	--   config = function()
	--     -- local builtin = require("statuscol.builtin")
	--     require("statuscol").setup({
	--       -- configuration goes here, for example:
	--       -- relculright = true,
	--       -- segments = {
	--       --   { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
	--       --   {
	--       --     sign = { name = { "Diagnostic" }, maxwidth = 2, auto = true },
	--       --     click = "v:lua.ScSa"
	--       --   },
	--       --   { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
	--       --   {
	--       --     sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
	--       --     click = "v:lua.ScSa"
	--       --   },
	--       -- }
	--     })
	--   end,
	-- },
	{
		"towolf/vim-helm",
		ft = "helm",
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				-- override markdown rendering so that completion and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
		},
	},
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("todo-comments").setup({
				highlight = {
					keyword = "bg",
				},
			})
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = "markdown",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		config = true,
	},
	{ "wakatime/vim-wakatime", event = "VeryLazy" },
}
