#!/usr/bin/env bash
set -e

cd ~/nixos-config
git add .
echo "Testing system configuration..."
sudo nixos-rebuild test --flake .#$(hostname)
echo "Applying system configuration..."
sudo nixos-rebuild switch --flake .#$(hostname)
echo "System rebuild complete!"
