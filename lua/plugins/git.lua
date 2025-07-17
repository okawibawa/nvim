return {
	{
		'folke/snacks.nvim',
		require("snacks").setup({
			lazygit = {
				configure = true,

				config = {
					os = {
						editPreset = "nvim-remote"
					},
					gui = {
						nerdFontsVersion = "3",
						theme = {
							lightTheme = false,
						},
					},
				},

				win = {
					style = "lazygit",
					width = 0.9,
					height = 0.9,
				},

				theme = {
					activeBorderColor = { fg = "MatchParen", bold = true },
					inactiveBorderColor = { fg = "FloatBorder" },
					selectedLineBgColor = { bg = "Visual" },
					unstagedChangesColor = { fg = "DiagnosticError" },
					defaultFgColor = { fg = "Normal" },
					optionsTextColor = { fg = "Function" },
					searchingActiveBorderColor = { fg = "MatchParen", bold = true },
					cherryPickedCommitBgColor = { fg = "Identifier" },
					cherryPickedCommitFgColor = { fg = "Function" },
				},
			},
		})
	}
}
