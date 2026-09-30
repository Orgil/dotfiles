return {
	{
		"smoka7/hop.nvim",
		version = "*",
		keys = {
			{
				"<space>w",
				function()
					require("hop").hint_words({ direction = require("hop.hint").HintDirection.AFTER_CURSOR })
				end,
			},
			{
				"<space>b",
				function()
					require("hop").hint_words({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR })
				end,
			},
			{ "<space>s", "<cmd>lua require'hop'.hint_char1()<cr>" },
			{
				"<space>j",
				function()
					require("hop").hint_lines({ direction = require("hop.hint").HintDirection.AFTER_CURSOR })
				end,
			},
			{
				"<space>k",
				function()
					require("hop").hint_lines({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR })
				end,
			},
		},
		opts = {
			keys = "etovxqpdygfblzhckisuran",
		},
	},
}
