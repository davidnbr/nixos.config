-- Disable LSP diagnostics for .env files
local lsp_hacks = vim.api.nvim_create_augroup("LspHacks", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = lsp_hacks,
  pattern = ".env*",
  callback = function(args)
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
})
