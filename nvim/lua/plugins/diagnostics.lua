return {
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000, -- load before other plugins touch diagnostics
		opts = {
			preset = "modern",
		},
	},
}
