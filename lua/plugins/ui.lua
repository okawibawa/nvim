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
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local lualine = require("lualine")

			local function get_file_icon_and_basename()
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
				if filename == "" then
					return "[No Name]"
				end
				local icon = require("nvim-web-devicons").get_icon_by_filetype(
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

			-- Custom Miasma theme for lualine
			local miasma = {
				normal = {
					a = { fg = "#c2c2b0", bg = "#78824b", gui = "bold" }, -- Foreground on Olive Blue
					b = { fg = "#c2c2b0", bg = "#222222" }, -- Foreground on Background
					c = { fg = "#c2c2b0", bg = "#222222" },
				},
				insert = {
					a = { fg = "#222222", bg = "#b36d43", gui = "bold" }, -- Background on Rusty Yellow
					b = { fg = "#c2c2b0", bg = "#222222" },
					c = { fg = "#c2c2b0", bg = "#222222" },
				},
				visual = {
					a = { fg = "#222222", bg = "#bb7744", gui = "bold" }, -- Background on Warm Purple
					b = { fg = "#c2c2b0", bg = "#222222" },
					c = { fg = "#c2c2b0", bg = "#222222" },
				},
				replace = {
					a = { fg = "#222222", bg = "#c9a554", gui = "bold" }, -- Background on Golden Cyan
					b = { fg = "#c2c2b0", bg = "#222222" },
					c = { fg = "#c2c2b0", bg = "#222222" },
				},
				command = {
					a = { fg = "#222222", bg = "#5f875f", gui = "bold" }, -- Background on Forest Green
					b = { fg = "#c2c2b0", bg = "#222222" },
					c = { fg = "#c2c2b0", bg = "#222222" },
				},
				inactive = {
					a = { fg = "#666666", bg = "#222222" }, -- Bright Black on Background
					b = { fg = "#666666", bg = "#222222" },
					c = { fg = "#666666", bg = "#222222" },
				},
			}

			lualine.setup({
				options = {
					icons_enabled = true,
					theme = "auto",

					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = { "alpha", "NvimTree", "Trouble", "lazy", "mason" },
					always_last_session = true,
					globalstatus = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = {
						{ "branch", icon = " " },
						{ get_file_icon_and_basename },
					},
					lualine_c = {
						-- { 'diff',
						--   colors = { added = { fg = '#5f875f' }, modified = { fg = '#b36d43' }, removed = { fg = '#685742' } }, -- Green, Yellow, Red
						--   symbols = { added = '+', modified = '~', removed = '-' }
						-- },
						{
							"diagnostics",
							sources = { "nvim_lsp" },
							symbols = { error = " ", warn = " ", info = " " },
							diagnostics_color = {
								error = { fg = "#685742" }, -- Red
								warn = { fg = "#b36d43" }, -- Yellow
								info = { fg = "#c9a554" }, -- Cyan
								hint = { fg = "#78824b" }, -- Blue
							},
						},
						{ get_lsp_clients },
					},
					lualine_x = {
						function()
							local encoding = vim.bo.fileencoding or "none"
							local filetype = vim.bo.filetype or "none"

							local eye_icon = ""

							return string.format("%s | %s %s", encoding, eye_icon, filetype)
						end,
					},
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = { "filename" },
					lualine_b = {},
					lualine_c = {},
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				extensions = {},
			})
		end,
	},
	{
		"folke/edgy.nvim",
		event = "VeryLazy",
		dependencies = { "akinsho/toggleterm.nvim" },
		opts = {
			bottom = {
				{
					ft = "terminal",
					size = { height = 0.3 },
					title = "Terminal",
					filter = function(buf, win)
						return vim.bo[buf].filetype == "terminal" and vim.w[win].toggleterm_direction == "horizontal"
					end,
					winhighlight = "Normal:Normal,NormalFloat:Normal", -- Use theme's Normal
				},
			},
			right = {
				{
					ft = "terminal",
					size = { width = 0.4 },
					title = "Terminal",
					filter = function(buf, win)
						return vim.bo[buf].filetype == "terminal" and vim.w[win].toggleterm_direction == "vertical"
					end,
					winhighlight = "Normal:Normal,NormalFloat:Normal", -- Use theme's Normal
				},
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("TermOpen", {
				callback = function(args)
					local term = require("toggleterm.terminal").get(vim.b[args.buf].terminal_job_id)
					if term then
						vim.w[args.buf].toggleterm_direction = term.direction
					end
				end,
			})
		end,
	},
}
