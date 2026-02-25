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
					"black", -- Python formatter
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

					-- JS/TS formatting is handled by none-ls (prettierd) only
					if client.name == "ts_ls" then
						client.server_capabilities.documentFormattingProvider = false
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
				end,
			})

			-- Format on save: single global autocmd; null-ls for web/astro/python, gopls for Go
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
				pattern = {
					"*.js",
					"*.jsx",
					"*.ts",
					"*.tsx",
					"*.json",
					"*.css",
					"*.scss",
					"*.md",
					"*.html",
					"*.astro",
					"*.lua",
					"*.py",
					"*.go",
				},
				callback = function(args)
					local bufnr = args.buf
					vim.lsp.buf.format({
						bufnr = bufnr,
						async = false,
						timeout_ms = 2000,
						filter = function(client)
							local ft = vim.bo[bufnr].filetype
							if ft == "go" then
								return client.name == "gopls"
							elseif ft == "python" then
								-- Prefer null-ls (Black) when available; fall back to ruff formatting
								if client.name == "null-ls" then
									return true
								end
								if client.name == "ruff" then
									return true
								end
								return false
							end
							return client.name == "null-ls"
						end,
					})
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
							diagnosticMode = "openFilesOnly", -- faster; use "workspace" only when you need cross-file analysis
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

			-- Prettier: use project config when present, else Neovim defaults
			local null_ls_utils = require("null-ls.utils")
			local prettier_root_pattern = null_ls_utils.root_pattern(
				".prettierrc",
				".prettierrc.js",
				".prettierrc.json",
				".prettierrc.yaml",
				".prettierrc.yml",
				"prettier.config.js",
				"prettier.config.cjs"
			)
			local eslint_root_pattern = null_ls_utils.root_pattern(
				".eslintrc",
				".eslintrc.js",
				".eslintrc.cjs",
				".eslintrc.yaml",
				".eslintrc.yml",
				".eslintrc.json",
				"eslint.config.js",
				"eslint.config.mjs",
				"eslint.config.cjs",
				"package.json"
			)
			local sources = {
				-- Prettier when project has its own config (no overrides)
				null_ls.builtins.formatting.prettierd.with({
					condition = function()
						return prettier_root_pattern(vim.api.nvim_buf_get_name(0)) ~= nil
					end,
				}),
				-- Default Prettier options when project has no config (print-width=100, etc.)
				null_ls.builtins.formatting.prettierd.with({
					condition = function()
						return prettier_root_pattern(vim.api.nvim_buf_get_name(0)) == nil
					end,
					extra_args = {
						"--print-width=100",
						"--tab-width=2",
						"--single-quote",
						"--trailing-comma=all",
					},
				}),
				null_ls.builtins.formatting.gofumpt,
				null_ls.builtins.formatting.goimports,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.black,
			}
			-- ESLint diagnostics only if the builtin exists (none-ls fork may not ship it; use none-ls-extras for eslint)
			local ok_eslint, eslint_d_builtin = pcall(require, "null-ls.builtins.diagnostics.eslint_d")
			if ok_eslint and eslint_d_builtin then
				sources[#sources + 1] = eslint_d_builtin.with({
					condition = function()
						return eslint_root_pattern(vim.api.nvim_buf_get_name(0)) ~= nil
					end,
				})
			end
			null_ls.setup({ sources = sources })
		end,
	},
}
