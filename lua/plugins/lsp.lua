return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"RRethy/vim-illuminate",
			"nvim-tree/nvim-web-devicons",
			"nvim-treesitter/nvim-treesitter",
			"b0o/schemastore.nvim",
			{ "mrjones2014/smart-splits.nvim", opts = {} },
			"j-hui/fidget.nvim",
			"nvimtools/none-ls.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local null_ls = require("null-ls")

			-- Mason setup
			mason.setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			-- LSP servers to install
			local servers = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"jsonls",
				"gopls",
				"pyright",
				"lua_ls",
				"eslint",
			}

			-- Tools to install
			require("mason-tool-installer").setup({
				ensure_installed = {
					"prettierd",
					"eslint_d",
					"gofumpt",
					"goimports",
					"black",
					"isort",
					"stylua",
				},
				auto_update = false,
				run_on_start = true,
			})

			mason_lspconfig.setup({
				ensure_installed = servers,
				automatic_installation = true,
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- IMPORTANT: Decide which tools format which files
			-- Prettier: JS/TS/HTML/CSS/JSON/Markdown
			-- LSP: Go, Python, Lua
			local prettier_formats = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"html",
				"css",
				"scss",
				"json",
				"jsonc",
				"markdown",
				"yaml",
			}

			-- Setup key mappings when LSP attaches
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					local bufnr = event.buf

					-- Disable formatting for JS/TS/HTML/CSS - let Prettier handle it
					if
						client
						and vim.tbl_contains({
							"ts_ls",
							"html",
							"cssls",
							"jsonls",
							"eslint",
							"tailwindcss",
						}, client.name)
					then
						client.server_capabilities.documentFormattingProvider = false
					end

					-- Key mappings
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
					vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
					vim.keymap.set("n", "<leader>fm", function()
						vim.lsp.buf.format({ async = true })
					end, { buffer = bufnr })

					-- ESLint auto-fix on save
					if client and client.name == "eslint" then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.code_action({
									context = { only = { "source.fixAll.eslint" }, diagnostics = {} },
									apply = true,
								})
							end,
						})
					end

					-- Document highlight
					if client and client.supports_method("textDocument/documentHighlight") then
						local hl_group = vim.api.nvim_create_augroup("lsp-highlight-" .. bufnr, {})
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = bufnr,
							group = hl_group,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd("CursorMoved", {
							buffer = bufnr,
							group = hl_group,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})

			-- Configure each LSP server
			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
						},
					},
				},
			})

			vim.lsp.config("html", { capabilities = capabilities })

			vim.lsp.config("cssls", {
				capabilities = capabilities,
				settings = {
					css = { lint = { unknownAtRules = "ignore" } },
					scss = { lint = { unknownAtRules = "ignore" } },
					less = { lint = { unknownAtRules = "ignore" } },
				},
			})

			vim.lsp.config("tailwindcss", {
				capabilities = capabilities,
				filetypes = {
					"html",
					"css",
					"scss",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
				},
			})

			vim.lsp.config("jsonls", {
				capabilities = capabilities,
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			vim.lsp.config("gopls", {
				capabilities = capabilities,
				settings = {
					gopls = {
						analyses = { unusedparams = true },
						staticcheck = true,
						gofumpt = true,
					},
				},
			})

			vim.lsp.config("pyright", { capabilities = capabilities })

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = { enable = false },
					},
				},
			})

			vim.lsp.config("eslint", { capabilities = capabilities })

			-- Enable all servers
			vim.lsp.enable(servers)

			-- null-ls: Only for formatting
			null_ls.setup({
				sources = {
					-- Prettier for JS/TS/HTML/CSS/JSON/etc
					null_ls.builtins.formatting.prettierd.with({
						filetypes = prettier_formats,
					}),

					-- Go formatting
					null_ls.builtins.formatting.gofumpt,
					null_ls.builtins.formatting.goimports,

					-- Python formatting
					null_ls.builtins.formatting.black,
					null_ls.builtins.formatting.isort,

					-- Lua formatting
					null_ls.builtins.formatting.stylua,
				},
			})

			-- Format on save (uses null-ls for JS/TS/etc, LSP for Go/Python/Lua)
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("format-on-save", { clear = true }),
				callback = function()
					vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
				end,
			})

			-- Diagnostic signs
			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			local signs_text = {}
			for type, icon in pairs(signs) do
				signs_text[vim.diagnostic.severity[type:upper()]] = icon
			end

			vim.diagnostic.config({
				virtual_text = { prefix = "●" },
				signs = { text = signs_text },
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
				},
			})

			-- Diagnostic keymaps
			vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float)
			vim.keymap.set("n", "[d", function()
				vim.diagnostic.jump({ count = -1, float = true })
			end)
			vim.keymap.set("n", "]d", function()
				vim.diagnostic.jump({ count = 1, float = true })
			end)
			vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist)
		end,
	},
}
