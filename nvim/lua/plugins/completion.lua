return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })
		end,
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
	},
	{
		"saghen/blink.cmp",
		version = "1.*", -- prebuilt fuzzy-matcher binaries are only published for release tags
		event = "InsertEnter",
		dependencies = { "L3MON4D3/LuaSnip" },
		opts = function()
			-- utils.icons.kinds have a trailing space baked in; blink adds its own padding
			local kind_icons = {}
			for kind, icon in pairs(require("utils").icons.kinds) do
				kind_icons[kind] = vim.trim(icon)
			end

			return {
				keymap = {
					preset = "none",
					["<C-Space>"] = { "show", "fallback" },
					["<C-e>"] = { "hide", "fallback" },
					["<C-n>"] = { "select_next", "show", "fallback" },
					["<C-p>"] = { "select_prev", "fallback" },
					["<C-u>"] = { "scroll_documentation_up", "fallback" },
					["<C-d>"] = { "scroll_documentation_down", "fallback" },
					["<Tab>"] = { "accept", "snippet_forward", "fallback" },
					["<S-Tab>"] = { "snippet_backward", "fallback" },
				},
				appearance = { kind_icons = kind_icons },
				completion = {
					list = { selection = { preselect = false, auto_insert = true } },
					menu = { border = "rounded" },
					documentation = { auto_show = true, window = { border = "rounded" } },
					ghost_text = { enabled = true },
				},
				snippets = { preset = "luasnip" },
				sources = {
					default = { "snippets", "lsp", "buffer", "path" },
				},
				cmdline = { enabled = false },
			}
		end,
	},
}
