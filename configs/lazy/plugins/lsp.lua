return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				basedpyright = {
					settings = {
						basedpyright = {
							disableOrganizeImports = true,
							analysis = {
								typeCheckingMode = "basic",
								diagnosticMode = "openFilesOnly",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								inlayHints = false,
							},
						},
					},
				},

				ruff = {
					init_options = {
						settings = {
							logLevel = "error",
						},
					},
				},

				gopls = {
					settings = {
						gopls = {
							analyses = {
								unusedparams = true,
								unusedwrite = true,
							},
							staticcheck = false,
							gofumpt = true,
							usePlaceholders = false,
							hints = {
								assignVariableTypes = false,
								compositeLiteralFields = false,
								compositeLiteralTypes = false,
								constantValues = false,
								functionTypeParameters = false,
								parameterNames = false,
								rangeVariableTypes = false,
							},
						},
					},
				},
			},
		},
	},
}
