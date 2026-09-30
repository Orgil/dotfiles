return {
	{ -- extra a/i text objects: arguments (a), function calls (f), next/last variants (an/al, in/il)
		"echasnovski/mini.ai",
		version = false,
		event = "VeryLazy",
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				search_method = "cover_or_next",
				custom_textobjects = {
					-- function call: vif / daf
					f = ai.gen_spec.function_call(),
				},
			}
		end,
	},
	{ -- surround, with vim-surround style keys (ys/cs/ds/yss/S) so muscle memory carries over
		"echasnovski/mini.surround",
		version = false,
		event = "VeryLazy",
		opts = {
			n_lines = 50,
			search_method = "cover_or_next",
			mappings = {
				add = "ys",
				delete = "ds",
				replace = "cs",
				find = "", -- disabled, vim-surround has no equivalent
				find_left = "",
				highlight = "",
				update_n_lines = "",
			},
		},
		config = function(_, opts)
			require("mini.surround").setup(opts)
			-- yss = surround the whole line, S in visual mode = add surrounding (as in vim-surround)
			vim.keymap.set("n", "yss", "ys_", { remap = true, desc = "Surround line" })
			vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true, desc = "Surround selection" })
		end,
	},
}
