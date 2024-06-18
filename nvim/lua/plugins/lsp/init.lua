return {
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
			-- {
			-- 	"folke/lazydev.nvim",
			-- 	opts = {
			-- 		experimental = { pathStrict = true },
			-- 		library = { plugins = { "nvim-dap-ui", "neotest" }, types = true, lazy = true },
			-- 	},
			-- },
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"simrat39/rust-tools.nvim",
			-- "jose-elias-alvarez/typescript.nvim",
			"p00f/clangd_extensions.nvim",
			{
				"b0o/SchemaStore.nvim",
				version = false, -- last release is way too old
			},
		},
		opts = {
			-- options for vim.diagnostic.config()
			diagnostics = {
				-- underline = true,
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
			inlay_hints = {
				enabled = true,
				exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
			},
			document_highlight = {
				enabled = true,
			},
			capabilities = {
				workspace = {
					fileOperations = {
						didRename = true,
						willRename = true,
					},
				},
			},
			autoformat = true,
			servers = {
				tailwindcss = {},
				solidity_ls_nomicfoundation = {
					mason = false,
				},
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
				gopls = {
					analyses = {
						nilness = true,
						unusedparams = true,
						unusedwrite = true,
						useany = true,
					},
					experimentalPostfixCompletions = true,
					experimentalWorkspaceModule = true,
					gofumpt = true,
					staticcheck = true,
					usePlaceholders = true,
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				},
				clangd = {
					server = {
						filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
					},
				},
				yamlls = {
					settings = {
						yaml = {
							keyOrdering = false,
						},
					},
				},
				rust_analyzer = {},
				lua_ls = {
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
			},
		},
		config = function(_, opts)
			-- setup formatting and keymaps
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					-- local buf = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					--
					-- if client.supports_method("textDocument/inlayHint") then
					-- 	local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
					-- 	if type(ih) == "function" then
					-- 		ih(buf, true)
					-- 	elseif type(ih) == "table" and ih.enable then
					-- 		ih.enable(buf, true)
					-- 	end
					-- end
					--
					if client.supports_method("textDocument/codeLens") and vim.lsp.codelens then
						vim.lsp.codelens.refresh()
						--- autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
						vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
							buffer = buf,
							callback = vim.lsp.codelens.refresh,
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
		"stevearc/conform.nvim",
		dependencies = { "mason.nvim" },
		-- keys = {
		--   {
		--     "<leader>ff",
		--     function()
		--       require("conform").format({ formatters = { "injected" } })
		--     end,
		--     mode = { "n", "v" },
		--     desc = "Format Injected Langs"
		--   }
		-- },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				-- Use a sub-list to run only the first available formatter
				javascript = { { "eslint_d", "eslint", "prettierd", "prettier" } },
				javascriptreact = { { "eslint_d", "eslint", "prettierd", "prettier" } },
				typescript = { { "eslint_d", "eslint", "prettierd", "prettier" } },
				typescriptreact = { { "eslint_d", "eslint", "prettierd", "prettier" } },
				css = { { "stylelint" } },
				go = { { "goimports", "golines", "", "prettier" } },
				proto = { { "buf" } },
				sql = { { "sql_formatter" } },
				["*"] = { "injected" },
			},
			formatters = {
				stdin = false,
				injected = { options = { ignore_errors = true } },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			},
		},
		config = function(_, opts)
			require("conform").formatters.sql_formatter =
				{ prepend_args = { "-c", vim.fn.expand("$HOME/.config/nvim/sql-formatter.json") } }
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("LazyFormat", {}),
				callback = function(event)
					require("conform").format({ buf = event.buf })
				end,
			})
			require("conform").setup(opts)
		end,
	},
	{
		"mfussenegger/nvim-lint",
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		opts = {
			-- Event to trigger linters
			linters_by_ft = {
				javascript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescript = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				go = { "golangcilint" },
				yaml = { "yamllint" },
				css = { "stylelint" },
				scss = { "stylelint" },
				proto = { "protolint" },
				-- Use the "*" filetype to run linters on all filetypes.
				-- ['*'] = { 'global linter' },
				-- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
			},
			linters = {},
		},
		config = function(_, opts)
			local lint = require("lint")

			local M = {}

			for name, linter in pairs(opts.linters) do
				if type(linter) == "table" and type(lint.linters[name]) == "table" then
					lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
				else
					lint.linters[name] = linter
				end
			end

			lint.linters_by_ft = opts.linters_by_ft
			local lint_augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })

			function M.lint()
				local names = lint._resolve_linter_by_ft(vim.bo.filetype)

				-- Add fallback linters.
				if #names == 0 then
					vim.list_extend(names, lint.linters_by_ft["_"] or {})
				end

				-- Add global linters.
				vim.list_extend(names, lint.linters_by_ft["*"] or {})

				-- Filter out linters that don't exist or don't match the condition.
				local ctx = { filename = vim.api.nvim_buf_get_name(0) }
				ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
				names = vim.tbl_filter(function(name)
					local linter = lint.linters[name]
					return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
				end, names)

				-- Run linters.
				if #names > 0 then
					lint.try_lint(names)
				end
			end

			function M.debounce(ms, fn)
				local timer = vim.loop.new_timer()
				return function(...)
					local argv = { ... }
					timer:start(ms, 0, function()
						timer:stop()
						vim.schedule_wrap(fn)(unpack(argv))
					end)
				end
			end

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = M.debounce(100, M.lint),
			})
		end,
	},
	-- {
	--   "pmizio/typescript-tools.nvim",
	--   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	--   opts = {},
	-- },
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
				"codelldb",
				"delve",
				"goimports",
				"golines",
				"eslint_d",
				"yamllint",
				"protolint",
				"sql-formatter",
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
		lazy = true,
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
		lazy = false,
		config = function()
			require("dap-go").setup()
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		lazy = false,
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
	{ "theHamsta/nvim-dap-virtual-text", config = true, lazy = false },
}
