-- =============================================================================
-- LSP Configuration (Neovim 0.11+) - FINAL VERSION
-- =============================================================================

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
			local mason_tool_installer = require("mason-tool-installer")
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

			-- LSP servers for Mason to install
			local servers = {
				"ts_ls", -- TypeScript/JavaScript
				"superhtml", -- HTML
				"cssls", -- CSS
				"tailwindcss", -- Tailwind CSS
				"jsonls", -- JSON
				"gopls", -- Go
				"pyright", -- Python
				"lua_ls", -- Lua
				"eslint", -- ESLint
				"ruff", -- Python
			}

			-- Formatters and linters for Mason to install
			mason_tool_installer.setup({
				ensure_installed = {
					"prettierd", -- JS/TS/HTML/CSS formatter
					"eslint_d", -- Fast ESLint
					"gofumpt", -- Go formatter
					"goimports", -- Go imports
					"stylua", -- Lua formatter
					"ruff",
				},
				auto_update = false,
				run_on_start = true,
			})

			mason_lspconfig.setup({
				ensure_installed = servers,
				automatic_installation = true,
			})

			-- =============================================================================
			-- GLOBAL LSP ATTACH AND FORMATTING LOGIC
			-- =============================================================================

			-- Global LSP Attach function
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local bufnr = ev.buf
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if not client then
						return
					end

					local opts = { buffer = bufnr, silent = true }

					-- Key mappings
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>fm", function()
						vim.lsp.buf.format({ async = true })
					end, opts)

					-- Highlight references
					if client:supports_method("textDocument/documentHighlight") then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = bufnr,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd("CursorMoved", {
							buffer = bufnr,
							callback = vim.lsp.buf.clear_references,
						})
					end

					if client:supports_method("textDocument/formatting") then
						if not vim.b[bufnr].format_on_save_set then
							vim.api.nvim_create_autocmd("BufWritePre", {
								buffer = bufnr,
								group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, { clear = true }),
								callback = function()
									local eslint_client = vim.lsp.get_clients({
										name = "eslint",
										bufnr = bufnr,
									})[1]
									if eslint_client then
										vim.lsp.buf_request_sync(bufnr, "workspace/executeCommand", {
											command = "eslint.applyAllFixes",
											arguments = { vim.uri_from_bufnr(bufnr) },
										}, 1000)
									end

									vim.lsp.buf.format({ async = false, bufnr = bufnr })
								end,
							})
							vim.b[bufnr].format_on_save_set = true
						end
					end
				end,
			})

			-- =============================================================================
			-- LSP SERVER CONFIGURATIONS
			-- =============================================================================

			-- Define custom LSP configurations using vim.lsp.config
			vim.lsp.config.ts_ls = {
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
				},
			}

			vim.lsp.config.tailwindcss = {
				filetypes = {
					"html",
					"css",
					"scss",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"vue",
					"svelte",
				},
				settings = {
					tailwindCSS = {
						experimental = {
							classRegex = {
								"tw`([^`]*)",
								'tw="([^"]*)',
								'tw={"([^"}]*)',
								"tw\\.\\w+`([^`]*)",
								"tw\\(.*?\\)`([^`]*)",
							},
						},
					},
				},
			}

			vim.lsp.config.jsonls = {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			}

			vim.lsp.config.gopls = {
				settings = {
					gopls = {
						analyses = { unusedparams = true },
						staticcheck = true,
						gofumpt = true,
					},
				},
			}

			vim.lsp.config.pyright = {
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
						},
					},
				},
				positionEncoding = "utf-8",
			}

			vim.lsp.config.ruff = {
				settings = {
					["source.organizeImports"] = {
						enabled = true,
					},
					["source.fixAll"] = {
						enabled = true,
					},
					args = {
						"--line-length=88",
						"--select=E,F,I", -- E=pycodestyle, F=pyflakes, I=isort
					},
				},
			}

			vim.lsp.config.lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = { library = vim.api.nvim_get_runtime_file("", true) },
						telemetry = { enable = false },
					},
				},
			}

			-- THE FIX: The entire vim.lsp.config.eslint block is now removed.
			-- Its functionality is handled by the global LspAttach autocmd above.

			-- Finally, enable all the LSP servers we've configured.
			vim.lsp.enable(servers)

			-- =============================================================================
			-- DIAGNOSTICS CONFIGURATION
			-- =============================================================================

			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.HINT] = " ",
						[vim.diagnostic.severity.INFO] = " ",
					},
				},
				virtual_text = { prefix = "●" },
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
			})

			-- Global key mappings for diagnostics
			vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float)
			vim.keymap.set("n", "[d", function()
				vim.diagnostic.jump({ count = -1, float = true })
			end)
			vim.keymap.set("n", "]d", function()
				vim.diagnostic.jump({ count = 1, float = true })
			end)
			vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist)

			-- =============================================================================
			-- NONE-LS CONFIGURATION
			-- =============================================================================

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.prettierd.with({
						-- condition = function(utils)
						--   return utils.root_has_file({
						--     ".prettierrc",
						--     ".prettierrc.js",
						--     ".prettierrc.json",
						--     ".prettierrc.yaml",
						--     ".prettierrc.yml",
						--     "prettier.config.js",
						--     "prettier.config.cjs" })
						-- end,
						extra_args = {
							"--print-width=100",
							"--tab-width=2",
							"--single-quote",
							"--trailing-comma=all",
						},
					}),
					null_ls.builtins.diagnostics.eslint_d,
					null_ls.builtins.formatting.gofumpt,
					null_ls.builtins.formatting.goimports,
					null_ls.builtins.formatting.stylua,
				},
			})
		end,
	},
}
