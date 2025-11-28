#!/usr/bin/env bash
set -e

cd ~/nixos.config
echo "Updating flake inputs..."
nix flake update
git add flake.lock
git commit -m "chore: update flake inputs" || true
echo "Rebuilding system with updates..."
sudo nixos-rebuild switch --flake .#$(hostname)
home-manager switch --flake .#$(whoami)
echo "Update complete!"
