return {
  -- Go extra configuration
  {
    "ray-x/go.nvim",
    opts = {
      goimports = "goimports", -- Use system goimports
      fillstruct = "fillstruct",
      dap_debug = false, -- Disable DAP for now
    },
  },
}
