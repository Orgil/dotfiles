local map = require("utils").map
local rt = require("rust-tools")

return {
	default = function()
		-- stylua: ignore start
		map("n", "<leader>gt", vim.lsp.buf.type_definition)
    map("n", "<leader>gd", vim.lsp.buf.declaration, { desc = "Go to declaration" })
    map("n", "<leader>d", vim.lsp.buf.definition, { desc = "Go to definition" })
		map("n", "<leader>gr", vim.lsp.buf.references)
		-- stylua: ignore end
		-- map("n", ";", vim.lsp.buf.hover)
		map("n", "<leader>gi", vim.lsp.buf.implementation)
		map("n", "<leader>k", vim.lsp.buf.signature_help)
		map("n", ";", function()
			vim.diagnostic.open_float()
		end)
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

		map("n", "<leader>ff", function()
			vim.lsp.buf.format({ async = true })
		end)
	end,
	tsserver = function()
    -- stylua: ignore start
    map("n", "<leader>d", ":TypescriptGoToSourceDefinition<cr>", { desc = "Go to definition" })
		-- stylua: ignore end
	end,
	rust_analyzer = function()
		-- Hover actions
		map("n", ";", rt.hover_actions.hover_actions)
		-- Code action groups
		map("n", "<leader>a", rt.code_action_group.code_action_group)
	end,
}
