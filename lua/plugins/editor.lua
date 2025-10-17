return {
	{
		"numToStr/Comment.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			require("Comment").setup({
				padding = true,

				sticky = true,

				ignore = "^$",

				toggler = {
					line = "gcc",
					block = "gbc",
				},

				opleader = {
					line = "gc",
					block = "gb",
				},

				extra = {
					above = "gcO",
					below = "gco",
					eol = "gcA",
				},

				mappings = {
					basic = true,
					extra = true,
				},

				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),

				post_hook = nil,
			})
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		config = function()
			require("ts_context_commentstring").setup({
				enable_autocmd = false,

				languages = {
					typescript = "// %s",
					css = "/* %s */",
					scss = "/* %s */",
					html = "<!-- %s -->",
					svelte = "<!-- %s -->",
					vue = "<!-- %s -->",
					json = "",
				},

				config = {
					javascript = {
						__default = "// %s",
						jsx_element = "{/* %s */}",
						jsx_fragment = "{/* %s */}",
						jsx_attribute = "// %s",
						comment = "// %s",
					},

					typescript = {
						__default = "// %s",
						tsx_element = "{/* %s */}",
						tsx_fragment = "{/* %s */}",
						tsx_attribute = "// %s",
						comment = "// %s",
					},

					css = "/* %s */",
					scss = "/* %s */",
					html = "<!-- %s -->",
					svelte = "<!-- %s -->",
					vue = "<!-- %s -->",
					json = "",
				},
			})
		end,
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				default_file_explorer = false,
				columns = {
					"icon",
					"permissions",
					"size",
					"mtime",
				},
				keymaps = {
					["g?"] = "actions.show_help",
					["<CR>"] = "actions.select",
					["<C-v>"] = "actions.select_vsplit",
					["<C-h>"] = "actions.select_split",
					["<C-t>"] = "actions.select_tab",
					["<C-p>"] = "actions.preview",
					["<C-c>"] = "actions.close",
					["<C-r>"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = "actions.tcd",
					["gs"] = "actions.change_sort",
					["gx"] = "actions.open_external",
					["g."] = "actions.toggle_hidden",
				},
				use_default_keymaps = true,
				view_options = {
					show_hidden = false,
				},
			})

			-- Keymap to open oil
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end,
	},
	{
		"nvzone/typr",
		dependencies = "nvzone/volt",
		opts = {},
		cmd = { "Typr", "TyprStats" },
	},
	{
		"mistricky/codesnap.nvim",
		build = "make build_generator",
		keys = {
			-- Snapshot
			{
				"<leader>cc",
				"<cmd>CodeSnap<cr>",
				mode = "x",
				desc = "Save selected code snapshot into clipboard",
			},
			{
				"<leader>cs",
				"<cmd>CodeSnapSave<cr>",
				mode = "x",
				desc = "Save selected code snapshot in ~/Pictures",
			},

			-- Snapshot with highlight
			{
				"<leader>cch",
				"<cmd>CodeSnapHighlight<cr>",
				mode = "x",
				desc = "Save selected code snapshot with highlight into clipboard",
			},
			{
				"<leader>csh",
				"<cmd>CodeSnapSaveHighlight<cr>",
				mode = "x",
				desc = "Save selected code snapshot with highlight in ~/Pictures",
			},
		},
		opts = {
			bg_theme = "dusk",
			save_path = "~/Pictures",
			has_breadcrumbs = true,
			watermark = "",
			code_font_family = "Maple Mono",
			bg_x_padding = 54,
			bg_y_padding = 14,
		},
	},
}
