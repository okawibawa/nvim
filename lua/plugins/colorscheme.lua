return {
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
  {
    "wtfox/jellybeans.nvim",
    lazy = false,
    priority = 1000,
    opts = {}, -- Optional
    config = function()
      require('jellybeans').setup {
        italics = false,
        bold = false,
      }

      vim.cmd.colorscheme 'jellybeans'
    end
  }
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
  --     vim.cmd.colorscheme 'catppuccin-macchiato'
  --   end
  -- },
}
