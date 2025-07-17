local plugins = {
	{ 'nvim-lua/plenary.nvim' },
	{ 'kylechui/nvim-surround', version = '*', config = true },
	{
		'm4xshen/autoclose.nvim',
		config = function()
			require('autoclose').setup {}
		end
	},
	{
		'windwp/nvim-ts-autotag',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = function()
			require('nvim-ts-autotag').setup {
				opts = {
					enable_close = true,
					enable_rename = true,
					enabled_close_on_slash = false
				}
			}
		end
	},
	{
		'junegunn/fzf.vim', event = 'VimEnter', dependencies = { 'junegunn/fzf' }
	},

	-- UI
	require 'plugins.ui',
	require 'plugins.colorscheme',

	-- Treesitter
	require 'plugins.treesitter',

	-- Completion
	require 'plugins.completion',

	-- LSP
	require 'plugins.lsp',

	-- Editor
	require 'plugins.editor',

	-- Snacks
	require 'plugins.snacks'
}

require('lazy').setup(plugins, {
	change_detection = {
		enabled = true,
		notify = false,
	}
})
