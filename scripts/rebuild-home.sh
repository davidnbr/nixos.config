#!/usr/bin/env bash
set -e

cd ~/nixos.config
git add .
echo "Applying home manager configuration..."
home-manager switch --flake .#dbecerra
echo "Home manager rebuild complete!"
