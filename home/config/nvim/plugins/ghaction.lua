return {
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				yaml = { "actionlint" },
			},
		},
	},
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				"actionlint",
			},
		},
	},
}
