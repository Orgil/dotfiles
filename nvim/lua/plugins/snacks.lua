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

local logo = {
	[[                                                                       ]],
	[[                                                                     ]],
	[[       ████ ██████           █████      ██                     ]],
	[[      ███████████             █████                             ]],
	[[      █████████ ███████████████████ ███   ███████████   ]],
	[[     █████████  ███    █████████████ █████ ██████████████   ]],
	[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
	[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
	[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
	[[                                                                       ]],
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
			input = {
				enabled = true,
				win = { keys = { i_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "i", expr = true } } },
			},
			dashboard = {
				preset = {
					header = table.concat(logo, "\n"),
					keys = {
					{ icon = " ", key = "n", desc = "New file", action = ":ene | startinsert" },
					{ icon = " ", key = "f", desc = "Find file", action = ":lua Snacks.picker.files()" },
					{ icon = "󰮗 ", key = "g", desc = "Find text", action = ":lua Snacks.picker.grep()" },
					{ icon = " ", key = "c", desc = "Config", action = ":e $MYVIMRC" },
					{ icon = " ", key = "s", desc = "Restore Session", action = function() require("persistence").load() end },
					{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
					{ icon = " ", key = "m", desc = "Mason", action = ":Mason" },
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "startup" },
				},
			},
			indent = {
				enabled = true,
				char = "▏",
				animate = { enabled = false },
				scope = { enabled = true, char = "▏", underline = false },
			},
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
