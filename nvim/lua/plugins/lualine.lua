return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
		opts = {
			options = {
				globalstatus = true,
				disabled_filetypes = { "Trouble", "neo-tree", "neo-tree-popup", "alpha", "NvimTree" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 1 } },
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
			winbar = {
				lualine_a = {},
				lualine_b = {
					{
						"filetype",
						colored = true, -- Displays filetype icon in color if set to true
						icon_only = true, -- Display only an icon for filetype
						icon = { align = "left" }, -- Display filetype icon on the right hand side
						-- icon =    {'X', align='right'}
						-- Icon string ^ in table is ignored in filetype component
					},
				},
				lualine_c = { { "filename", path = 1 }, "diagnostics" },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			inactive_winbar = {
				lualine_a = {},
				lualine_b = {
					{
						"filetype",
						colored = true, -- Displays filetype icon in color if set to true
						icon_only = true, -- Display only an icon for filetype
						icon = { align = "left" }, -- Display filetype icon on the right hand side
						-- icon =    {'X', align='right'}
						-- Icon string ^ in table is ignored in filetype component
					},
				},
				lualine_c = { { "filename", path = 1 }, "diagnostics" },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		},
	},
}
