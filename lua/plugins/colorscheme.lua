return {
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
  --   config = function()
  --     vim.cmd.colorscheme 'catppuccin-mocha'
  --   end
  -- },
}
