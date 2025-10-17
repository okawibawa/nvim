return {
  -- Mason: Package manager
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end
  },

  -- Mason LSP bridge
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'ts_ls',
          'html',
          'cssls',
          'tailwindcss',
          'jsonls',
          'gopls',
          'pyright',
          'lua_ls',
          'eslint',
        },
        automatic_installation = true,
      })
    end
  },

  -- Auto-install tools
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-tool-installer').setup({
        ensure_installed = {
          'prettierd',
          'eslint_d',
          'black',
          'isort',
        },
        auto_update = false,
        run_on_start = true,
      })
    end
  },

  -- LSP Configuration (New API)
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- IMPORTANT: Set up LspAttach BEFORE configuring servers
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local bufnr = event.buf

          if not client then return end

          -- Keymaps
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
              buffer = bufnr,
              silent = true,
              desc = desc or ''
            })
          end

          map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
          map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
          map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
          map('n', 'gr', vim.lsp.buf.references, 'Go to references')
          map('n', 'K', vim.lsp.buf.hover, 'Hover documentation')
          map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
          map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code action')

          -- ESLint auto-fix
          if client.name == 'eslint' then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.code_action({
                  context = { only = { 'source.fixAll' }, diagnostics = {} },
                  apply = true,
                })
              end,
            })
          end

          -- Document highlighting
          if client.server_capabilities.documentHighlightProvider then
            local group = vim.api.nvim_create_augroup('lsp-highlight-' .. bufnr, { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = bufnr,
              group = group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd('CursorMoved', {
              buffer = bufnr,
              group = group,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- Configure servers using new API
      vim.lsp.config('ts_ls', {
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
            }
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
            }
          }
        }
      })

      vim.lsp.config('html', {
        capabilities = capabilities,
      })

      vim.lsp.config('cssls', {
        capabilities = capabilities,
        settings = {
          css = { lint = { unknownAtRules = "ignore" } },
          scss = { lint = { unknownAtRules = "ignore" } },
          less = { lint = { unknownAtRules = "ignore" } }
        }
      })

      vim.lsp.config('tailwindcss', {
        capabilities = capabilities,
        filetypes = {
          'html', 'css', 'scss',
          'javascript', 'javascriptreact',
          'typescript', 'typescriptreact'
        },
      })

      vim.lsp.config('jsonls', {
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })

      vim.lsp.config('gopls', {
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })

      vim.lsp.config('pyright', {
        capabilities = capabilities,
      })

      vim.lsp.config('lua_ls', {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config('eslint', {
        capabilities = capabilities,
      })

      -- Enable all servers
      vim.lsp.enable({
        'ts_ls',
        'html',
        'cssls',
        'tailwindcss',
        'jsonls',
        'gopls',
        'pyright',
        'lua_ls',
        'eslint',
      })

      -- Diagnostic configuration
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      local signs_text = {}
      for type, icon in pairs(signs) do
        signs_text[vim.diagnostic.severity[type:upper()]] = icon
      end

      vim.diagnostic.config({
        virtual_text = { prefix = '●' },
        signs = { text = signs_text },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = true,
        },
      })

      -- Global diagnostic keymaps
      vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end)
      vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end)
      vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist)
    end
  },

  -- Modern formatting
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          javascript = { 'prettierd' },
          javascriptreact = { 'prettierd' },
          typescript = { 'prettierd' },
          typescriptreact = { 'prettierd' },
          html = { 'prettierd' },
          css = { 'prettierd' },
          scss = { 'prettierd' },
          json = { 'prettierd' },
          jsonc = { 'prettierd' },
          markdown = { 'prettierd' },
          yaml = { 'prettierd' },
          go = { 'gofumpt', 'goimports' },
          python = { 'isort', 'black' },
        },

        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })

      -- Manual format keymap
      vim.keymap.set('n', '<leader>fm', function()
        require('conform').format({ async = true, lsp_fallback = true })
      end, { desc = 'Format buffer' })
    end,
  },

  -- Dependencies
  { 'b0o/schemastore.nvim' },
}
