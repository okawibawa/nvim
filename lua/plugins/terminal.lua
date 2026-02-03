return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		event = "VeryLazy",
		opts = {
			size = function(term)
				if term.direction == "horizontal" then
					return vim.o.lines * 0.3 -- 30% height for horizontal
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
			float_opts = {
				border = "rounded",
				width = math.floor(vim.o.columns * 0.8),
				height = math.floor(vim.o.lines * 0.8),
				winhighlight = "Normal:Normal,NormalFloat:Normal",
			},
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
				"<leader>t",
				function()
					require("toggleterm").toggle(0, nil, vim.fn.getcwd(), "float")
				end,
				desc = "Toggle terminal (quick)",
			},
			{
				"<leader>tf",
				function()
					require("toggleterm").toggle(0, nil, vim.fn.getcwd(), "float")
				end,
				desc = "Toggle floating terminal",
			},
			{
				"<leader>th",
				function()
					require("toggleterm").toggle(0, nil, vim.fn.getcwd(), "horizontal")
				end,
				desc = "Toggle horizontal terminal",
			},
			{
				"<leader>tv",
				function()
					require("toggleterm").toggle(0, nil, vim.fn.getcwd(), "vertical")
				end,
				desc = "Toggle vertical terminal",
			},
			{
				"<C-t>",
				"<C-\\><C-n>",
				mode = "t",
				desc = "Exit terminal insert mode",
			},
			{
				"<C-h>",
				"<C-\\><C-n><C-w>h",
				mode = "t",
				desc = "Go to left window",
			},
			{
				"<C-j>",
				"<C-\\><C-n><C-w>j",
				mode = "t",
				desc = "Go to bottom window",
			},
			{
				"<C-k>",
				"<C-\\><C-n><C-w>k",
				mode = "t",
				desc = "Go to top window",
			},
			{
				"<C-l>",
				"<C-\\><C-n><C-w>l",
				mode = "t",
				desc = "Go to right window",
			},
			{
				"<C-c>",
				"<C-c>",
				mode = "t",
				desc = "Send Ctrl+C to terminal process",
			},
			{
				"<leader>t1",
				function()
					require("toggleterm").toggle(1)
				end,
				desc = "Toggle terminal 1",
			},
			{
				"<leader>t2",
				function()
					require("toggleterm").toggle(2)
				end,
				desc = "Toggle terminal 2",
			},
			{
				"<leader>t3",
				function()
					require("toggleterm").toggle(3)
				end,
				desc = "Toggle terminal 3",
			},
			{
				"<leader>tg",
				function()
					local Terminal = require("toggleterm.terminal").Terminal
					local lazygit = Terminal:new({
						cmd = "lazygit",
						dir = "git_dir",
						direction = "float",
						float_opts = { border = "rounded" },
						on_open = function(term)
							vim.cmd("startinsert!")
						end,
					})
					lazygit:toggle()
				end,
				desc = "Open lazygit",
			},
			{
				"<leader>tc",
				"<cmd>ToggleTerm<cr>",
				mode = { "n", "t" },
				desc = "Close terminal",
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
				desc = "Kill terminal process and close",
			},
		},
	},
}
