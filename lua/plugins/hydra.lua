return {
	{
		"anuvyklack/hydra.nvim",
		lazy = false,
		config = function()
			local Hydra = require("hydra")

			Hydra({
				name = "Side scroll",
				mode = "n",
				body = "z",
				hint = false,
				heads = {
					{ "h", "5zh" },
					{ "l", "5zl", { desc = "←/→" } },
					{ "H", "zH" },
					{ "L", "zL", { desc = "half screen ←/→" } },
				},
			})
		end,
	},
}
