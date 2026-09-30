-- nvim-treesitter `main` branch: no module system (highlight/ensure_installed opts are gone).
-- Parsers are installed with `install()`, and highlight is started per-buffer below (folds are handled by nvim-ufo).
local parsers = {
		"bash",
		"c",
		"c_sharp",
		"cmake",
		"comment",
		"cpp",
		"css",
		"diff",
		"dockerfile",
		"dot",
		"func",
		"gdscript",
		"godot_resource",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
		"glsl",
		"hlsl",
		"go",
		"gomod",
		"gowork",
		"gosum",
		"graphql",
		"vimdoc",
		"regex",
		"html",
		"http",
		"ini",
		"javascript",
		"jq",
		"jsdoc",
		"json",
		"jsonc",
		"json5",
		"llvm",
		"lua",
		"make",
		"markdown",
		"markdown_inline",
		"proto",
		"scss",
		"solidity",
		"todotxt",
		"tsx",
		"vim",
		"yaml",
		"sql",
		"typescript",
}

return {
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		version = false,
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			ts.setup({})

			-- install only parsers that exist and are missing (install() is async and needs the tree-sitter CLI)
			local available = ts.get_available()
			local installed = ts.get_installed()
			local missing = vim.tbl_filter(function(lang)
				return vim.tbl_contains(available, lang) and not vim.tbl_contains(installed, lang)
			end, parsers)
			if #missing > 0 then
				if vim.fn.executable("tree-sitter") == 1 then
					ts.install(missing)
				else
					vim.notify("nvim-treesitter: `tree-sitter` CLI not found, skipping parser install", vim.log.levels.WARN)
				end
			end

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					if vim.b[args.buf].bigfile then
						return
					end
					local lang = vim.treesitter.language.get_lang(args.match)
					if not lang then
						return
					end
					pcall(vim.treesitter.start, args.buf, lang)
				end,
			})
		end,
	},
	{ -- sticky header of the function/class/block the cursor is inside
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			max_lines = 3,
			trim_scope = "outer",
			on_attach = function(buf)
				return not vim.b[buf].bigfile
			end,
		},
	},
}
