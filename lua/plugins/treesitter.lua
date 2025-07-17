return {
	{
		'nvim-treesitter/nvim-treesitter', run = ":TSUpdate",
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = {
					-- Web Development
					'javascript', 'typescript', 'tsx', 'html', 'css', 'json',

					-- Py and Go
					'python', 'go', 'gomod', 'gowork',

					-- Config/Docs
					'yaml', 'dockerfile', 'markdown', 'markdown_inline', 'toml',

					-- Neovim Config
					'lua'
				},
        modules = {},
        sync_install = {},
        ignore_install = {},
        auto_install = {},
				highlight = { enable = true },
				indend = { enable = true },
			})
		end
	},
}
