return {
  {
    "nvim-neotest/neotest",
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Run nearest test" },
      {
        "<leader>tf",
        function()
          require("neotest").run.run({ vim.fn.getcwd(), extra_args = { "-coverprofile", "coverage.out" } })
        end,
        desc = "Run all tests (coverage)",
      },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test summary" },
      { "<leader>to", function() require("neotest").output_panel.toggle() end, desc = "Test output" },
    },
    dependencies = {
      "nvim-neotest/nvim-nio",
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
            jestCommand = "pnpm jest",
            env = { CI = true },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          }),
        },
      })

    end,
  },
  {
    "andythigpen/nvim-coverage",
    cmd = { "Coverage", "CoverageLoad", "CoverageSummary", "CoverageToggle", "CoverageShow", "CoverageHide", "CoverageClear" },
    keys = {
      { "<leader>cl", "<cmd>CoverageLoad<cr>", desc = "Coverage load" },
      { "<leader>cs", "<cmd>CoverageSummary<cr>", desc = "Coverage summary" },
      { "<leader>ct", "<cmd>CoverageToggle<cr>", desc = "Coverage toggle" },
    },
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("coverage").setup()
    end,
  },
}
