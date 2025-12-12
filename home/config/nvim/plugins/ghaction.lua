return {
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				ghaction = { "actionlint" },
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
