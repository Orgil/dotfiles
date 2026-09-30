-- globs kept out of file/grep results (ported from the old telescope file_ignore_patterns / rg args)
local exclude = {
	".git",
	"node_modules",
	"dist",
	".history",
	".import",
	"*.import",
	"*.lock",
	"pnpm-lock.yaml",
	"package-lock.json",
	"*.min.js",
	"*.map",
	"*.svg",
}

-- dropdown without a preview pane, like the old find_files/buffers dropdown
local dropdown = { preset = "dropdown", hidden = { "preview" } }

return {
	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 1000,
		keys = {
			{ "<c-p>", function() Snacks.picker.files() end, desc = "Find files" },
			{ "<c-f>", function() Snacks.picker.grep() end, desc = "Live grep" },
			{ "<c-b>", function() Snacks.picker.buffers() end, desc = "Buffers" },
			{ "<leader>s", function() Snacks.picker.lsp_symbols() end, desc = "Symbols" },
		},
		opts = {
			input = { enabled = true },
			picker = {
				enabled = true,
				ui_select = true,
				prompt = " ❯ ",
				sources = {
					files = { hidden = true, exclude = exclude, layout = dropdown },
					grep = { hidden = true, exclude = exclude, args = { "--trim" } },
					buffers = {
						layout = dropdown,
						win = { input = { keys = { ["<c-d>"] = { "bufdelete", mode = { "n", "i" } } } } },
					},
					lsp_symbols = { layout = dropdown },
				},
			},
		},
	},
}
