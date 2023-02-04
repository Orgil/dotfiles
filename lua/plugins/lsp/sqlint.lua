local nls = require("null-ls")
local helpers = require("null-ls.helpers")
-- local configFile = vim.fn.expand("$HOME/.config/nvim/pg_format.conf")
local sqlint = {
	name = "SQL",
	method = nls.methods.DIAGNOSTICS,
	filetypes = { "sql" },
	generator = helpers.generator_factory({
		command = "sqlint",
		to_stdin = true,
		from_stderr = true,
		format = "line",
		on_output = helpers.diagnostics.from_patterns({
			{
				pattern = [[:(%d+):([%w-/]+):([A-Z]+) (.*)]],
				groups = { "row", "column", "severity", "message" },
			},
		}),
	}),
}

return sqlint
