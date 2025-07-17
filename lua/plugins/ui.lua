-- lua/plugins/ui.lua
return {
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require('bufferline').setup({})
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local lualine = require('lualine')

      -- Get file icon, name, and optionally directory
      local function get_file_icon_and_basename()
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
        if filename == "" then return "[No Name]" end
        local icon = require('nvim-web-devicons').get_icon_by_filetype(
          vim.fn.fnamemodify(filename, ":e"),
          { default_icon = true }
        )
        return string.format("%s %s", icon, filename)
      end

      -- Get Git branch
      local function get_git_branch()
        local branch_name = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD 2>/dev/null")[1]
        if branch_name and branch_name ~= "" then
          return " " .. branch_name -- Git icon + branch name as a single string
        else
          return "" -- Return empty string if no branch, Lualine will hide the component
        end
      end

      -- Get active LSP client names
      local function get_lsp_clients()
        local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
        if #clients > 0 then
          local client_names = vim.tbl_map(function(client)
            return client.name
          end, clients)
          return " " .. table.concat(client_names, ", ")
        else
          return " No LSP"
        end
      end

      lualine.setup({
        options = {
          icons_enabled = true,
          theme = 'jellybeans',

          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = { 'alpha', 'NvimTree', 'Trouble', 'lazy', 'mason' },
          always_last_session = true,
          globalstatus = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = {
            { 'branch', icon = ' ' },
            { get_file_icon_and_basename },
          },
          lualine_c = {
            -- Based on the image, diffs were not in this exact spot.
            -- Add them back if you want them here.
            -- { 'diff',
            --   colors = { added = { fg = 'green' }, modified = { fg = 'yellow' }, removed = { fg = 'red' } },
            --   symbols = { added = '+', modified = '~', removed = '-' }
            -- },
            {
              'diagnostics',
              sources = { 'nvim_lsp' },
              symbols = { error = ' ', warn = ' ', info = ' ' },
              -- Lualine's built-in themes often handle colors.
              -- If 'ayu_dark' theme defines these, you don't need custom colors here.
              -- If you want to force specific colors, use hex codes or `vim.api.nvim_get_hl`
              -- diagnostics_color = { error = 'red', warn = 'yellow', info = 'blue' }
            },
            { get_lsp_clients },
          },
          lualine_x = {
            -- This is for `utf-8 |  |  lua`
            function()
              local encoding = vim.bo.fileencoding or 'none'
              local fileformat = vim.bo.fileformat or 'none'
              local filetype = vim.bo.filetype or 'none'

              local linux_icon = ''
              local eye_icon = ''

              -- Ensure icons are rendered correctly by your font
              return string.format("%s | %s | %s %s", encoding, linux_icon, eye_icon, filetype)
            end,
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = { 'filename' },
          lualine_b = {},
          lualine_c = {},
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = {},
      })
    end
  },
}
