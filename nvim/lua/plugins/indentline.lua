return {
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("ibl").setup({
				indent = { char = "▏" },
				scope = {
					show_start = false,
					show_end = false,
					injected_languages = false,
				},
			})
			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
		end,
		-- opts = {
		-- 	-- indent = {
		-- 	-- 	char = "▏",
		-- 	-- },
		-- 	debounce = 100,
		-- 	indent = { char = "|" },
		-- 	whitespace = { highlight = { "Whitespace", "NonText" } },
		-- 	scope = { exclude = { "lua" } },
		-- 	-- use_treesitter = true,
		-- 	-- show_first_indent_level = false,
		-- 	-- show_trailing_blankline_indent = false,
		-- 	-- filetype_exclude = {
		-- 	-- 	"neogitstatus",
		-- 	-- 	"NeoTree",
		-- 	-- 	"mason",
		-- 	-- 	"",
		-- 	-- 	"lspinfo",
		-- 	-- 	"packer",
		-- 	-- 	"checkhealth",
		-- 	-- 	"help",
		-- 	-- 	"man",
		-- 	-- 	"dashboard",
		-- 	-- 	"git",
		-- 	-- 	"markdown",
		-- 	-- 	"text",
		-- 	-- 	"terminal",
		-- 	-- 	"NvimTree",
		-- 	-- },
		-- 	-- buftype_exclude = {
		-- 	-- 	"terminal",
		-- 	-- 	"packer",
		-- 	-- 	"nofile",
		-- 	-- 	"quickfix",
		-- 	-- 	"prompt",
		-- 	-- },
		-- },
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
