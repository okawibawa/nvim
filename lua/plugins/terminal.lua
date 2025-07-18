return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return vim.o.lines * 0.3   -- 30% height for horizontal
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4 -- 40% width for vertical
        end
      end,
      open_mapping = nil,
      shade_terminals = false,
      start_in_insert = true,
      insert_mappings = false,
      terminal_mappings = true,
      persist_size = true,
      direction = "float",
      float_opts = { border = "rounded", width = math.floor(vim.o.columns * 0.8), height = math.floor(vim.o.lines * 0.8), winhighlight = "Normal:Normal,NormalFloat:Normal" },
      highlights = { Normal = { link = "Normal" }, NormalFloat = { link = "Normal" }, TermCursor = { link = "Cursor" } },
      close_on_exit = true,
      shell = vim.o.shell,
      highlights = {
        Normal = { link = "Normal" },
        NormalFloat = { link = "Normal" },
        TermCursor = { link = "Cursor" },
      },
    },
    keys = {
      {
        "<leader>tf",
        function()
          require("toggleterm").toggle(0, nil, vim.fn.getcwd(), "float")
        end,
        desc = "Toggle floating terminal"
      },
      {
        "<leader>th",
        function()
          require("toggleterm").toggle(0, nil, vim.fn.getcwd(), "horizontal")
        end,
        desc = "Toggle horizontal terminal"
      },
      {
        "<leader>tv",
        function()
          require("toggleterm").toggle(0, nil, vim.fn.getcwd(), "vertical")
        end,
        desc = "Toggle vertical terminal"
      },
      {
        "<C-t>",
        "<C-\\><C-n>",
        mode = "t",
        desc = "Exit terminal insert mode"
      },
      {
        "<C-c>",
        "<C-c>",
        mode = "t",
        desc = "Send Ctrl+C to terminal process"
      },
      {
        "<leader>tc",
        "<cmd>ToggleTerm<cr>",
        mode = { "n", "t" },
        desc = "Close terminal"
      },
      {
        "<leader>tk",
        function()
          local term = require("toggleterm.terminal").get_all()[1]
          if term then
            term:shutdown()
          else
            vim.notify("No active terminal found", vim.log.levels.WARN)
          end
        end,
        mode = { "n", "t" },
        desc = "Kill terminal process and close"
      },
    },
  },
}
