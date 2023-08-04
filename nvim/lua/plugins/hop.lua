return {
	{
		"phaazon/hop.nvim",
		branch = "v2", -- optional but strongly recommended
		keys = {
			{ "<space>w", "<cmd>lua require'hop'.hint_words()<cr>" },
			{ "<space>b", "<cmd>lua require'hop'.hint_words()<cr>" },
			{ "<space>s", "<cmd>lua require'hop'.hint_char1()<cr>" },
			{ "<space>j", "<cmd>lua require'hop'.hint_lines()<cr>" },
			{ "<space>k", "<cmd>lua require'hop'.hint_lines()<cr>" },
		},
		opts = {
			keys = "etovxqpdygfblzhckisuran",
		},
	},
}
