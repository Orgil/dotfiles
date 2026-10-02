local map = require("utils").map

---@param bufnr integer
---@return fun(mode: string|string[], lhs: string, rhs: string|function, opts?: table)
local function bufmap(bufnr)
	return function(mode, lhs, rhs, opts)
		opts = opts and vim.deepcopy(opts) or {}
		opts.buffer = bufnr
		map(mode, lhs, rhs, opts)
	end
end

return {
	default = function(bufnr)
		local map = bufmap(bufnr)
    -- stylua: ignore start
    map("n", "<leader>gt", vim.lsp.buf.type_definition)
    map("n", "<leader>gd", vim.lsp.buf.declaration, { desc = "Go to declaration" })
    map("n", "<leader>d", vim.lsp.buf.definition, { desc = "Go to definition" })
		map("n", "<leader>u", function()
			Snacks.picker.lsp_references()
		end, { desc = "Usages" })
		-- stylua: ignore end
		-- map("n", ";", vim.lsp.buf.hover)
		map("n", "<leader>gi", vim.lsp.buf.implementation)
		map("n", "<leader>k", vim.lsp.buf.signature_help)
		-- map("n", "<leader>gd", vim.lsp.buf.d, { desc = "Documentation" })

		-- map("n", "<space>wa", vim.lsp.buf.add_workspace_folder)
		-- map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder)
		-- map("n", "<space>wl", function()
		-- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		-- end)

		map("n", "<leader>a", function()
			vim.lsp.buf.code_action()
		end)
		map("n", "<leader>r", vim.lsp.buf.rename)
	end,
	rust_analyzer = function(bufnr)
		local map = bufmap(bufnr)
		-- Hover actions
		map("n", ";", function()
			vim.cmd.RustLsp({ "hover", "actions" })
		end)
		-- Code action groups
		map("n", "<leader>a", function()
			vim.cmd.RustLsp("codeAction")
		end)
	end,
}
