return {
  -- {
  --   "tinted-theming/tinted-nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("tinted-colorscheme").with_config({
  --       supports = {
  --         tinty        = true,
  --         tinted_shell = false,
  --         live_reload  = true,
  --       },
  --       highlights = {
  --         telescope         = true,
  --         telescope_borders = false,
  --         indentblankline   = true,
  --         notify            = true,
  --         ts_rainbow        = true,
  --         cmp               = true,
  --         illuminate        = true,
  --         lsp_semantic      = true,
  --         mini_completion   = true,
  --         dapui             = true,
  --       },
  --     })

  --     vim.api.nvim_create_autocmd("ColorScheme", {
  --       callback = function()
  --         require("lualine").setup({
  --           options = {
  --             theme = "auto",
  --           },
  --         })
  --       end,
  --     })

  --     require("tinted-colorscheme").setup()
  --   end,
  -- },
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_background = 'hard'
      vim.g.gruvbox_material_foreground = 'material'
      vim.g.gruvbox_material_ui_contrast = "low"
      vim.g.gruvbox_material_float_style = "dim"
      vim.g.gruvbox_material_disable_italic_comment = 1
      vim.g.gruvbox_material_enable_italic = 0
      vim.g.gruvbox_material_transparent_background = 2

      vim.cmd.colorscheme 'gruvbox-material'
    end
  }
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   priority = 1000,
  --   config = function()
  --     require('gruvbox').setup({
  --       italic = {
  --         strings = false,
  --         emphasis = false,
  --         comments = false,
  --         operators = false,
  --         folds = false,
  --       }
  --     })
  --     vim.cmd.colorscheme 'gruvbox'
  --   end,
  -- }
  -- {
  --   'AlexvZyl/nordic.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('nordic').setup({
  --       italic_comments = false,
  --       bold_keywords = false,
  --     })
  --     vim.cmd.colorscheme 'nordic'
  --   end
  -- }
  -- {
  --   "xero/miasma.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme "miasma"
  --   end,
  -- }
  -- {
  --   "wtfox/jellybeans.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {}, -- Optional
  --   config = function()
  --     require('jellybeans').setup {
  --       italics = false,
  --       bold = false,
  --     }

  --     vim.cmd.colorscheme 'jellybeans'
  --   end
  -- }
  -- {
  --   "arturgoms/moonbow.nvim",
  --   config = function()
  --     vim.cmd.colorscheme 'moonbow'
  --   end
  -- },
  -- {
  --   'catppuccin/nvim',
  --   name = 'catppuccin',
  --   priority = 1000,
  --   opts = {},
  --   config = function()
  --     require('catppuccin').setup {
  --       no_italic = true,
  --       no_bold = true,
  --       transparent_background = true
  --     }

  --     vim.cmd.colorscheme 'catppuccin-mocha'
  --   end
  -- },
}
