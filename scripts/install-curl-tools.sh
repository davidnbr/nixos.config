#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST="$SCRIPT_DIR/../home/curl-installs.txt"

if [[ ! -f "$MANIFEST" ]]; then
  echo "Error: $MANIFEST not found" >&2
  exit 1
fi

echo "Installing curl-managed tools from $MANIFEST..."

while IFS='|' read -r name url _version; do
  [[ "$name" =~ ^#.*$ || -z "${name// }" ]] && continue
  name="${name// /}"
  url="${url// /}"
  echo "  -> $name ($url)"
  curl -fsSL "$url" | sh
done < "$MANIFEST"

echo "Done."
