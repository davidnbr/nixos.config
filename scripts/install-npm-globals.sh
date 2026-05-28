#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_FILE="$SCRIPT_DIR/../home/npm-globals.txt"

if [[ ! -f "$PACKAGES_FILE" ]]; then
  echo "Error: $PACKAGES_FILE not found" >&2
  exit 1
fi

# Ensure npm prefix is set
npm config set prefix "$HOME/.npm-global"

echo "Installing global npm packages from $PACKAGES_FILE..."

while IFS= read -r line; do
  # Skip comments and empty lines
  [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
  echo "  -> $line"
  npm install -g "$line"
done < "$PACKAGES_FILE"

echo "Done. Ensure ~/.npm-global/bin is in your PATH."
