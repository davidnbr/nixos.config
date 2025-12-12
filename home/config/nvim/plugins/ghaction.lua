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
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"actionlint",
			},
		},
	},
}
