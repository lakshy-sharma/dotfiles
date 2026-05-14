return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"go",
				"python",
				"cpp",
				"c",
				"lua",
				"bash",
				"json",
				"yaml",
				"toml",
				"markdown",
			},
			highlight = {
				enable = true,
			},
		},
	},
}
