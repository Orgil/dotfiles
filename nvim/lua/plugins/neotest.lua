local map = require("utils").map

return {
	{
		"nvim-neotest/neotest",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-go",
			"nvim-neotest/neotest-jest",
		},
		config = function()
			-- get neotest namespace (api call creates or returns namespace)
			-- local neotest_ns = vim.api.nvim_create_namespace("neotest")
			-- vim.diagnostic.config({
			-- 	virtual_text = {
			-- 		format = function(diagnostic)
			-- 			local message =
			-- 				diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
			-- 			return message
			-- 		end,
			-- 	},
			-- }, neotest_ns)

			require("neotest").setup({
				-- your neotest config here
				adapters = {
					require("neotest-go")({
						experimental = {
							test_table = true,
						},
						args = { "-count=1", "-timeout=60s" },
					}),
					require("neotest-jest")({
						jestCommand = "npm test --",
						jestConfigFile = "custom.jest.config.ts",
						env = { CI = true },
						cwd = function(path)
							return vim.fn.getcwd()
						end,
					}),
				},
			})

			map("n", "<leader>tt", function()
				require("neotest").run.run()
			end)
			map("n", "<leader>tf", function()
				require("neotest").run.run({ vim.fn.getcwd(), extra_args = { "-coverprofile", "coverage.out" } })
			end)
			map("n", "<leader>td", function()
				require("neotest").run.run({ strategy = "dap" })
			end)

			map("n", "<leader>ts", function()
				require("neotest").summary.toggle()
			end)
			map("n", "<leader>to", function()
				require("neotest").output_panel.toggle()
			end)
		end,
	},
	{
		"andythigpen/nvim-coverage",
		lazy = false,
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("coverage").setup()

			map("n", "<leader>cl", ":CoverageLoad<cr>")
			map("n", "<leader>cs", ":CoverageSummary<cr>")
			map("n", "<leader>ct", ":CoverageToggle<cr>")
		end,
	},
}
