#!/usr/bin/env bash
set -e

cd ~/nixos.config
echo "Updating flake inputs..."
nix flake update
git add flake.lock
git commit -m "chore: update flake inputs" || true
echo "Applying home manager configuration..."
home-manager switch --flake .#dbecerra
echo "Update complete!"
