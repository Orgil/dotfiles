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
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		after = "mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{ "j-hui/fidget.nvim", tag = "legacy", event = "LspAttach", config = true },
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
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({
				disable_filetype = { "TelescopePrompt", "vim" },
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
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on(
				"confirm_done",
				cmp_autopairs.on_confirm_done({
					map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
					auto_select = true, -- automatically select the first item
					insert = false, -- use insert confirm behavior instead of replace
					map_char = {
						-- modifies the function or method delimiter by filetypes
						all = "(",
						tex = "{",
					},
				})
			)
		end,
	},
	{ "windwp/nvim-ts-autotag", config = true },
	{ "tpope/vim-repeat" },
	{
		"folke/trouble.nvim",
		lazy = true,
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
		lazy = false,
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
			map("n", "<leader>ft", ":ToggleTerm size=20 direction=float<cr>")
		end,
	},
	{
		"mbbill/undotree",
		lazy = false,
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
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},
	{
		"anuvyklack/pretty-fold.nvim",
		lazy = true,
		config = function()
			require("pretty-fold").setup({
				keep_indentation = true,
				fill_char = "•",
				sections = {
					left = {
						"content",
					},
					right = {
						" ",
						"number_of_folded_lines",
						" ",
						"••••",
					},
				},
			})
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
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
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
		config = function()
			require("todo-comments").setup({
				highlight = {
					keyword = "bg",
				},
			})
		end,
	},
	{ "ellisonleao/glow.nvim", config = true, cmd = "Glow", lazy = true },
	-- {
	-- 	"glepnir/lspsaga.nvim",
	-- 	event = "BufRead",
	-- 	config = function()
	-- 		require("lspsaga").setup({
	-- 			lightbulb = {
	-- 				enable = false,
	-- 				enable_in_insert = false,
	-- 				sign = true,
	-- 				sign_priority = 40,
	-- 				virtual_text = true,
	-- 			},
	-- 		})
	-- 	end,
	-- 	dependencies = {
	-- 		{ "nvim-tree/nvim-web-devicons" },
	-- 		--Please make sure you install markdown and markdown_inline parser
	-- 		{ "nvim-treesitter/nvim-treesitter" },
	-- 	},
	-- },
}
