return {
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPost",
		opts = {
			char = "▏",
			buftype_exclude = { "terminal", "packer" },
			use_treesitter = true,
			show_first_indent_level = false,
			filetype_exclude = { "help", "alpha", "packer", "neogitstatus", "NeoTree", "mason", "" },
			show_trailing_blankline_indent = false,
		},
	},
	{
		-- symbol = "│",
		"echasnovski/mini.indentscope",
		version = false, -- wait till new 0.7.0 release to put it back on semver
		event = "BufReadPre",
		opts = {
			symbol = "▏",
			options = { try_as_border = true },
			draw = {
				-- Delay (in ms) between event and start of drawing scope indicator
				delay = 0,

				-- Animation rule for scope's first drawing. A function which, given
				-- next and total step numbers, returns wait time (in ms). See
				-- |MiniIndentscope.gen_animation| for builtin options. To disable
				-- animation, use `require('mini.indentscope').gen_animation.none()`.
				--minidoc_replace_start animation = --<function: implements constant 20ms between steps>,
				animation = function(_, _)
					return 10
				end,
				--minidoc_replace_end
			},
		},
		config = function(_, opts)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"lazy",
					"mason",
					"",
					"neotest-summary",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
			require("mini.indentscope").setup(opts)
		end,
	},
}
