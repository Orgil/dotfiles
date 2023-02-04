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
			highlight = { enable = true },
			indent = { enable = true },
			context_commentstring = { enable = true, enable_autocmd = false },
			ensure_installed = "all",
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
	{ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" },
}
