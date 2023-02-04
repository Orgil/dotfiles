return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
		opts = {
			options = {
				disabled_filetypes = { "Trouble", "neo-tree", "neo-tree-popup", "alpha" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = {},
				lualine_y = { "filetype" },
				lualine_z = {},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = { "filename" },
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		},
	},
}
