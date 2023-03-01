local map = require("utils").map

return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			{
				-- only needed if you want to use the commands with "_with_window_picker" suffix
				"s1n7ax/nvim-window-picker",
				config = function()
					require("window-picker").setup({
						selection_chars = "ABCDEFGHIJK",
						include_current_win = false,
						filter_rules = {
							-- filter using buffer options
							bo = {
								-- if the file type is one of following, the window will be ignored
								filetype = { "neo-tree", "neo-tree-popup", "notify", "alpha" },

								-- if the buffer type is one of following, the window will be ignored
								buftype = { "terminal", "quickfix" },
							},
						},
						fg_color = "#191726",
						other_win_hl_color = "#569fba",
					})
				end,
			},
		},
		lazy = false,
		config = function()
			vim.cmd([[let g:neo_tree_remove_legacy_commands = 1]])
			require("neo-tree").setup({
				popup_border_style = "rounded",
				default_component_configs = {
					icon = {
						folder_closed = "",
						folder_open = "",
						folder_empty = "",
					},
				},
				use_default_mappings = false,
				window = {
					mappings = {
						["<esc>"] = "revert_preview",
						["P"] = { "toggle_preview", config = { use_float = true } },
						["l"] = "focus_preview",
						["i"] = "split_with_window_picker",
						["s"] = "vsplit_with_window_picker",
						-- ["t"] = "open_tabnew",
						-- ["<cr>"] = "open_drop",
						["t"] = "open_tab_drop",
						["o"] = "open_with_window_picker",
						["<cr>"] = "open_drop",
						--["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
						["ma"] = {
							"add",
							-- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
							-- some commands may take optional config options, see `:h neo-tree-mappings` for details
							config = {
								show_path = "relative", -- "none", "relative", "absolute"
							},
						},
						["md"] = "delete",
						["mr"] = "rename",
						["mc"] = "copy_to_clipboard",
						["mx"] = "cut_to_clipboard",
						["mp"] = "paste_from_clipboard",
						["mm"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
						["R"] = "refresh",
						["?"] = "show_help",
						["<"] = "prev_source",
						[">"] = "next_source",
					},
				},
				filesystem = {
					filtered_items = {
						never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
							".DS_Store",
							"thumbs.db",
						},
						always_show = {
							".github",
							".env",
						},
					},
					window = {
						mappings = {
							["<bs>"] = "navigate_up",
							["."] = "set_root",
							["/"] = "fuzzy_finder",
							["I"] = "toggle_hidden",
							["mo"] = "system_open",
						},
					},
					use_libuv_file_watcher = true,
					commands = {
						system_open = function(state)
							local node = state.tree:get_node()
							local path = node:get_id()
							-- macOs: open file in default application in the background.
							-- Probably you need to adapt the Linux recipe for manage path with spaces. I don't have a mac to try.
							vim.api.nvim_command("silent !open -g " .. path)
							-- Linux: open file in default application
							-- vim.api.nvim_command(string.format("silent !xdg-open '%s'", path))
						end,
					},
				},
				buffers = {
					follow_current_file = true, -- This will find and focus the file in the active buffer every
					-- time the current file is changed while the tree is open.
					group_empty_dirs = true, -- when true, empty folders will be grouped together
					show_unloaded = true,
					window = {
						position = "float",
						mappings = {
							["bd"] = "buffer_delete",
							["<bs>"] = "navigate_up",
							["."] = "set_root",
						},
					},
				},
				git_status = {
					window = {
						position = "float",
						mappings = {
							["gA"] = "git_add_all",
							["gu"] = "git_unstage_file",
							["ga"] = "git_add_file",
							["gr"] = "git_revert_file",
							["gc"] = "git_commit",
							["gp"] = "git_push",
							["gg"] = "git_commit_and_push",
						},
					},
				},
			})

			map("n", "<f4>", ":Neotree toggle<cr>")
			map("n", "<leader>nt", ":Neotree reveal<cr>")
			map("n", "<leader>nb", ":Neotree source=buffers position=float<cr>")
		end,
	},
}
