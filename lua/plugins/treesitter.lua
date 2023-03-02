return {
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		version = false,
		build = ":TSUpdate",
		event = "BufReadPost",
		keys = {
			{ "<S-space>", desc = "Increment selection" },
			{ "<bs>", desc = "Schrink selection", mode = "x" },
		},
		opts = {
			highlight = { enable = true, additional_vim_regex_highlighting = true },
			indent = { enable = false },
			context_commentstring = { enable = true, enable_autocmd = false },
			ensure_installed = {
				"bash",
				"c",
				"c_sharp",
				"cmake",
				"comment",
				"cpp",
				"css",
				"diff",
				"dockerfile",
				"dot",
				"func",
				"gdscript",
				"godot_resource",
				"git_rebase",
				"gitattributes",
				"gitcommit",
				"gitignore",
				"glsl",
				"hlsl",
				"go",
				"gomod",
				"gowork",
				"gosum",
				"graphql",
				"help",
				"html",
				"http",
				"ini",
				"javascript",
				"jq",
				"jsdoc",
				"json",
				"jsonc",
				"json5",
				"llvm",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"proto",
				"scss",
				"solidity",
				"todotxt",
				"tsx",
				"vim",
				"yaml",
				"sql",
				"typescript",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<S-space>",
					node_incremental = "<S-space>",
					scope_incremental = "<nop>",
					node_decremental = "<bs>",
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	-- { "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" },
}
