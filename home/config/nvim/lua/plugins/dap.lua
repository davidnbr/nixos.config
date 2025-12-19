return {
  -- Disable any DAP configurations that might conflict
  {
    "mfussenegger/nvim-dap",
    enabled = false, -- Disable for now, can enable later with proper Nix setup
  },
  {
    "rcarriga/nvim-dap-ui", 
    enabled = false,
  },
}
