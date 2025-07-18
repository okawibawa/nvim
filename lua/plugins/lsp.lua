return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'RRethy/vim-illuminate',
      'nvim-tree/nvim-web-devicons',
      'nvim-treesitter/nvim-treesitter',
      'b0o/schemastore.nvim',
      { 'mrjones2014/smart-splits.nvim', opts = {} },
      { 'j-hui/fidget.nvim',             opts = {} },
      'nvimtools/none-ls.nvim',
      'nvim-lua/plenary.nvim'
    },
    config = function()
      local lspconfig = require('lspconfig')
      local mason = require('mason')
      local mason_lspconfig = require('mason-lspconfig')
      local null_ls = require('null-ls')

      -- Mason setup
      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })

      -- LSP servers to install
      local servers = {
        'ts_ls',       -- TypeScript/JavaScript
        'superhtml',   -- HTML
        'cssls',       -- CSS
        'tailwindcss', -- Tailwind CSS
        'jsonls',      -- JSON
        'gopls',       -- Go
        'pyright',     -- Python
        'lua_ls',      -- Lua
        'eslint',      -- ESLint
      }

      -- Formatters and linters to install
      local mason_tool_installer = require('mason-tool-installer')
      mason_tool_installer.setup({
        ensure_installed = {
          'prettierd', -- JS/TS/HTML/CSS formatter
          'eslint_d',  -- Fast ESLint
          'gofumpt',   -- Go formatter
          'goimports', -- Go imports
          'black',     -- Python formatter
          'isort',     -- Python import sorter
          'stylua',    -- Lua formatter
        },
        auto_update = false,
        run_on_start = true,
      })

      mason_lspconfig.setup({
        ensure_installed = servers,
        automatic_installation = true,
      })

      -- Capabilities for completion
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- LSP attach function
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }

        -- Key mappings
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts) -- Conflicting with navigation keymap
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>fm', function()
          vim.lsp.buf.format({ async = true })
        end, opts)

        -- Format on save
        if client:supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end

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
      end

      -- TypeScript/JavaScript
      lspconfig.ts_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            }
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            }
          }
        }
      })

      -- HTML
      lspconfig.html.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- CSS
      lspconfig.cssls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          css = {
            validate = true,
            lint = {
              unknownAtRules = "ignore"
            }
          },
          scss = {
            validate = true,
            lint = {
              unknownAtRules = "ignore"
            }
          },
          less = {
            validate = true,
            lint = {
              unknownAtRules = "ignore"
            }
          }
        }
      })

      -- Tailwind CSS
      lspconfig.tailwindcss.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = {
          'html', 'css', 'scss', 'javascript', 'javascriptreact',
          'typescript', 'typescriptreact', 'vue', 'svelte'
        },
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                "tw`([^`]*)",
                "tw=\"([^\"]*)",
                "tw={\"([^\"}]*)",
                "tw\\.\\w+`([^`]*)",
                "tw\\(.*?\\)`([^`]*)",
              },
            },
          },
        },
      })

      -- JSON with schema support
      lspconfig.jsonls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- Go
      lspconfig.gopls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })

      -- Python
      lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true
            }
          }
        }
      })

      -- Lua
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      -- ESLint
      lspconfig.eslint.setup({
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          -- Auto-fix on save
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
        capabilities = capabilities,
      })

      -- null-ls setup for additional formatting/linting
      null_ls.setup({
        sources = {
          -- JavaScript/TypeScript
          null_ls.builtins.formatting.prettierd.with({
            filetypes = {
              "javascript", "javascriptreact", "typescript", "typescriptreact",
              "vue", "css", "scss", "less", "html", "json", "jsonc", "yaml",
              "markdown", "graphql", "handlebars"
            },
          }),
          null_ls.builtins.diagnostics.eslint_d,

          -- Go
          null_ls.builtins.formatting.gofumpt,
          null_ls.builtins.formatting.goimports,

          -- Python
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,

          -- Lua
          null_ls.builtins.formatting.stylua,
        },
        on_attach = on_attach,
      })

      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'always',
          header = '',
          prefix = '',
        },
      })

      -- Diagnostic signs
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
        },
        signs = {
          text = signs_icons,
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'always',
          header = '',
          prefix = '',
        },
      })

      -- Global key mappings
      vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end)
      vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end)
      vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist)
    end
  }
}
