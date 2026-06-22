#!/usr/bin/env bash
set -euo pipefail

# Restores the writable Neovim/LazyVim state that nix does NOT manage:
#   - ~/.config/nvim/lazyvim.json  (enabled extras; LazyVim writes this at runtime)
#   - ~/.config/nvim/init.lua      (bootstrap entry point)
#   - removes LazyVim's starter lua/plugins/example.lua cruft
# The nix-managed parts (lua/config, lua/plugins) are handled by home-manager.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTRAS_FILE="$SCRIPT_DIR/../home/nvim-extras.txt"
NVIM_DIR="$HOME/.config/nvim"

if [[ ! -f "$EXTRAS_FILE" ]]; then
  echo "Error: $EXTRAS_FILE not found" >&2
  exit 1
fi

mkdir -p "$NVIM_DIR"

# 1. init.lua — create only if absent (don't clobber a customized one)
if [[ ! -f "$NVIM_DIR/init.lua" ]]; then
  echo "Writing $NVIM_DIR/init.lua"
  printf '%s\n' \
    '-- bootstrap lazy.nvim, LazyVim and your plugins' \
    'require("config.lazy")' > "$NVIM_DIR/init.lua"
fi

# 2. lazyvim.json — set .extras from the manifest, preserving LazyVim's other
#    keys (version/news/...) when the file already exists.
echo "Syncing extras into $NVIM_DIR/lazyvim.json"
mapfile -t extras < <(grep -vE '^\s*#|^\s*$' "$EXTRAS_FILE")
extras_json="$(printf '%s\n' "${extras[@]}" | jq -R . | jq -s .)"

if [[ -f "$NVIM_DIR/lazyvim.json" ]]; then
  tmp="$(mktemp)"
  jq --argjson e "$extras_json" '.extras = $e' "$NVIM_DIR/lazyvim.json" > "$tmp"
  mv "$tmp" "$NVIM_DIR/lazyvim.json"
else
  jq -n --argjson e "$extras_json" \
    '{extras: $e, install_version: 8, version: 8}' > "$NVIM_DIR/lazyvim.json"
fi

# 3. Drop LazyVim starter cruft
rm -f "$NVIM_DIR/lua/plugins/example.lua"

echo "Done. Restart Neovim (extras sync on next launch)."
