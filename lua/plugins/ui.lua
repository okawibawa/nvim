return {
  -- {
  --   'akinsho/bufferline.nvim',
  --   version = "*",
  --   dependencies = "nvim-tree/nvim-web-devicons",
  --   config = function(buf_number, buf_list)
  --     require('bufferline').setup({
  --     })
  --   end
  -- },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local lualine = require('lualine')

      local function get_file_icon_and_basename()
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
        if filename == "" then return "[No Name]" end
        local icon = require('nvim-web-devicons').get_icon_by_filetype(
          vim.fn.fnamemodify(filename, ":e"),
          { default_icon = true }
        )
        return string.format("%s %s", icon, filename)
      end

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
            -- { 'diff',
            --   colors = { added = { fg = 'green' }, modified = { fg = 'yellow' }, removed = { fg = 'red' } },
            --   symbols = { added = '+', modified = '~', removed = '-' }
            -- },
            {
              'diagnostics',
              sources = { 'nvim_lsp' },
              symbols = { error = ' ', warn = ' ', info = ' ' },
            },
            { get_lsp_clients },
          },
          lualine_x = {
            function()
              local encoding = vim.bo.fileencoding or 'none'
              local filetype = vim.bo.filetype or 'none'

              local eye_icon = ''

              return string.format("%s | %s %s", encoding, eye_icon, filetype)
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
