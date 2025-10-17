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
        "ts_ls",       -- TypeScript/JavaScript
        "superhtml",   -- HTML
        "cssls",       -- CSS
        "tailwindcss", -- Tailwind CSS
        "jsonls",      -- JSON
        "gopls",       -- Go
        "pyright",     -- Python
        "lua_ls",      -- Lua
        "eslint",      -- ESLint
      }

      -- Formatters and linters for Mason to install
      mason_tool_installer.setup({
        ensure_installed = {
          "prettierd", -- JS/TS/HTML/CSS formatter
          "eslint_d",  -- Fast ESLint
          "gofumpt",   -- Go formatter
          "goimports", -- Go imports
          "black",     -- Python formatter
          "isort",     -- Python import sorter
          "stylua",    -- Lua formatter
        },
        auto_update = false,
        run_on_start = true,
      })

      mason_lspconfig.setup({
        ensure_installed = servers,
        automatic_installation = true,
      })

      -- =============================================================================
      -- NEW LSP CONFIGURATION (vim.lsp.config)
      -- =============================================================================

      -- Global LSP Attach function
      -- This runs whenever an LSP client attaches to a buffer.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local bufnr = ev.buf
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client then return end

          local opts = { buffer = bufnr, silent = true }

          -- Key mappings (keep this as is)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          -- ... all your other keymaps ...
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

          -- Highlight references (keep this as is)
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

          -- Enable builtin completion for this LSP client
          if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
          end

          -- THE FIX: Create a SINGLE, unified BufWritePre autocommand
          -- We only want to create this ONCE per buffer, so we check if it already exists.
          if not vim.b[bufnr].format_on_save_set then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, { clear = true }),
              callback = function()
                -- First, run EslintFixAll if the eslint client is attached
                local eslint_client = vim.lsp.get_active_clients({ name = "eslint", bufnr = bufnr })[1]
                if eslint_client then
                  vim.cmd("EslintFixAll")
                end

                -- Then, run the general formatter. This will format with null-ls or any other LSP formatter.
                -- `async = false` ensures it completes before the save.
                vim.lsp.buf.format({ async = false, bufnr = bufnr })
              end,
            })
            -- Set a flag on the buffer to indicate the autocommand has been set
            vim.b[bufnr].format_on_save_set = true
          end
        end,
      })

      -- Define custom LSP configurations using vim.lsp.config
      -- These will be merged with the defaults from nvim-lspconfig.
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

      vim.lsp.config.eslint = {
        -- Custom on_attach for ESLint to run EslintFixAll on save
        on_attach = function(client, bufnr)
          if client.name == "eslint" then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end
        end,
      }

      -- Finally, enable all the LSP servers we've configured.
      vim.lsp.enable(servers)

      -- =============================================================================
      -- NONE-LS CONFIGURATION (for formatting/linting)
      -- =============================================================================

      null_ls.setup({
        sources = {
          -- JavaScript/TypeScript Formatting
          null_ls.builtins.formatting.prettierd.with({
            condition = function(utils)
              return utils.root_has_file({
                ".prettierrc",
                ".prettierrc.js",
                ".prettierrc.json",
                ".prettierrc.yaml",
                ".prettierrc.yml",
                "prettier.config.js",
                "prettier.config.cjs",
              })
            end,
          }),

          -- JavaScript/TypeScript Diagnostics
          null_ls.builtins.diagnostics.eslint_d,

          -- Go Formatting
          null_ls.builtins.formatting.gofumpt,
          null_ls.builtins.formatting.goimports,

          -- Python Formatting
          null_ls.builtins.formatting.black.with({
            condition = function(utils)
              return utils.root_has_file({ "pyproject.toml", "setup.cfg", "tox.ini" })
            end,
          }),
          null_ls.builtins.formatting.isort.with({
            condition = function(utils)
              return utils.root_has_file({ "pyproject.toml", "setup.cfg", "tox.ini" })
            end,
          }),

          -- Lua Formatting
          null_ls.builtins.formatting.stylua.with({
            condition = function(utils)
              local is_config = vim.fn.expand('%:~'):match('config/nvim')
              local has_stylua_config = utils.root_has_file({ "stylua.toml", ".stylua.toml" })
              return not is_config and has_stylua_config
            end,
          }),
        },

        -- -- on_attach for none-ls to trigger format on save
        -- on_attach = function(client, bufnr)
        --   if client.supports_method("textDocument/formatting") then
        --     vim.api.nvim_create_autocmd("BufWritePre", {
        --       buffer = bufnr,
        --       callback = function()
        --         vim.lsp.buf.format({ async = false })
        --       end,
        --     })
        --   end
        -- end,
      })

      -- =============================================================================
      -- DIAGNOSTICS CONFIGURATION
      -- =============================================================================

      -- Note: The blog post mentions setting borders with vim.o.winborder
      vim.opt.winborder = "rounded"

      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- Diagnostic signs (using icons from your original config)
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Global key mappings for diagnostics
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
