local map = require("utils").map

return {
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
			{
				"folke/neodev.nvim",
				opts = {
					experimental = { pathStrict = true },
					library = { plugins = { "nvim-dap-ui" }, types = true },
				},
			},
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"simrat39/rust-tools.nvim",
			"jose-elias-alvarez/typescript.nvim",
			"p00f/clangd_extensions.nvim",
			{
				"b0o/SchemaStore.nvim",
				version = false, -- last release is way too old
			},
		},
		opts = {
			-- options for vim.diagnostic.config()
			diagnostics = {
				underline = true,
				signs = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					focusable = false,
					header = { "", "Normal" },
					prefix = "",
					source = "always",
				},
				virtual_text = {
					spacing = 4,
					source = "always",
					severity = {
						min = vim.diagnostic.severity.HINT,
					},
				},
			},
			autoformat = true,
			servers = {
				jsonls = {
					-- lazy-load schemastore when needed
					on_new_config = function(new_config)
						new_config.settings.json.schemas = new_config.settings.json.schemas or {}
						vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
					end,
					settings = {
						json = {
							format = {
								enable = true,
							},
							validate = { enable = true },
						},
					},
				},
				gopls = {},
				tsserver = {
					flags = {
						allow_incremental_sync = true,
					},
				},
				clangd = {
					server = {
						filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
					},
				},
				rust_analyzer = {},
				sumneko_lua = {
					-- mason = false, -- set to false if you don't want this server to be installed with mason
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			},
			setup = {
				clangd = function(_, opts)
					require("clangd_extensions").setup(opts)
					return true
				end,
				rust_analyzer = function(_, opts)
					require("rust-tools").setup({
						tools = {
							autoSetHints = true,
							runnables = {
								use_telescope = true,
							},
							inlay_hints = {
								only_current_line = true,
								show_parameter_hints = false,
								parameter_hints_prefix = "",
								other_hints_prefix = "",
							},
						},
						server = opts,
					})
					return true
				end,
				tsserver = function(_, opts)
					require("typescript").setup({
						go_to_source_definition = {
							fallback = true, -- fall back to standard LSP definition on failure
						},
						server = opts,
					})
					return true
				end,
				-- Specify * to use this function as a fallback for any server
				-- ["*"] = function(server, opts) end,
			},
		},
		config = function(_, opts)
			-- setup formatting and keymaps
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local buffer = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)

					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = vim.api.nvim_create_augroup("LspFormat." .. buffer, {}),
							buffer = buffer,
							callback = function()
								if opts.autoformat then
									local ft = vim.bo[buffer].filetype
                  -- stylua: ignore
									local have_nls = #require("null-ls.sources").get_available( ft, "NULL_LS_FORMATTING") > 0

									vim.lsp.buf.format(vim.tbl_deep_extend("force", {
										bufnr = buffer,
										filter = function(clienter)
											if have_nls then
												return clienter.name == "null-ls"
											end
											return clienter.name ~= "null-ls"
										end,
									}, opts.format or {}))
								end
							end,
						})
					end

					local keymaps = require("plugins.lsp.keymaps")
					keymaps.default()
					if keymaps and keymaps[client.name] then
						keymaps[client.name]()
					end
				end,
			})

			-- diagnostics
			for name, icon in pairs(require("utils").icons.diagnostics) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end
			vim.diagnostic.config(opts.diagnostics)

			local servers = opts.servers
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			local function setup(server)
				local server_opts = servers[server] or {}
				server_opts.capabilities = capabilities
				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end

			local mlsp = require("mason-lspconfig")
			local available = mlsp.get_available_servers()

			local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
					if server_opts.mason == false or not vim.tbl_contains(available, server) then
						setup(server)
					else
						ensure_installed[#ensure_installed + 1] = server
					end
				end
			end

			require("mason-lspconfig").setup({ ensure_installed = ensure_installed })
			require("mason-lspconfig").setup_handlers({ setup })
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = "BufReadPre",
		dependencies = { "mason.nvim" },
		opts = function()
			local nls = require("null-ls")
			local configFile = vim.fn.expand("$HOME/.config/nvim/sql-formatter.json")
			return {
				-- debug = true,
				sources = {
					-- diagnostics
					require("plugins.lsp.sqlint"),
					nls.builtins.diagnostics.protolint,
					require("typescript.extensions.null-ls.code-actions"),
					nls.builtins.formatting.golines,
					nls.builtins.formatting.goimports,
					nls.builtins.formatting.protolint,
					nls.builtins.formatting.stylua,
					nls.builtins.formatting.sql_formatter.with({
						args = { "-c", configFile },
					}),
				},
			}
		end,
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		opts = {
			ui = {
				border = "rounded",
				width = 0.4,
				height = 0.6,
			},
			ensure_installed = {
				"stylua",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			for _, tool in ipairs(opts.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end,
	},
	{
		"mfussenegger/nvim-dap",
		config = function()
			local mason_registry = require("mason-registry")
			local codelldb = mason_registry.get_package("codelldb") -- note that this will error if you provide a non-existent package name
			local codelldb_path = codelldb:get_install_path()

			local dap = require("dap")
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					-- CHANGE THIS to your path!
					command = codelldb_path .. "/codelldb",
					args = { "--port", "${port}" },

					-- On windows you may have to uncomment this:
					-- detached = false,
				},
			}

			dap.configurations.cpp = {
				{
					name = "Launch codelldb",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}

			dap.configurations.c = dap.configurations.cpp
			dap.configurations.rust = dap.configurations.cpp

			vim.keymap.set("n", "<F5>", dap.continue)
			vim.keymap.set("n", "<F10>", dap.step_over)
			vim.keymap.set("n", "<F11>", dap.step_into)
			vim.keymap.set("n", "<F12>", dap.step_out)
			vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<Leader>lp", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end)
			vim.keymap.set("n", "<Leader>dr", dap.repl.open)
			vim.keymap.set("n", "<Leader>dl", dap.run_last)
			vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
				require("dap.ui.widgets").hover()
			end)
			vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
				require("dap.ui.widgets").preview()
			end)
			vim.keymap.set("n", "<Leader>df", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.frames)
			end)
			vim.keymap.set("n", "<Leader>ds", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.scopes)
			end)
		end,
	},
	{
		"leoluz/nvim-dap-go",
		config = function()
			require("dap-go").setup()
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("dapui").setup()
			local dap, dapui = require("dap"), require("dapui")
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
	{ "theHamsta/nvim-dap-virtual-text", config = true },
}
