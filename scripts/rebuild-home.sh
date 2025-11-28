#!/usr/bin/env bash
set -e

cd ~/nixos.config
git add .
echo "Applying home manager configuration..."
home-manager switch --flake .#$(whoami)
echo "Home manager rebuild complete!"
