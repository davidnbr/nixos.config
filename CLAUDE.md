# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS configuration repository using Home Manager for user environment management on Ubuntu. It uses Nix flakes to manage dependencies and configurations for a development environment.

## Architecture

- **Entry Point**: `flake.nix` - Defines the flake inputs, outputs, and system configuration
- **User Configuration**: `home/dbecerra.nix` - Main Home Manager configuration with packages and settings
- **Shell Prompt**: `home/starship.nix` - Starship prompt configuration with Catppuccin theming
- **Code Quality**: `home/pre-commit-config.yaml` - Pre-commit hooks for various linters and security checks

## Common Commands

### Building and Applying Configuration
```bash
# Build the configuration
nix build .#homeConfigurations.dbecerra.activationPackage

# Apply the configuration
home-manager switch --flake .#dbecerra

# Build and switch in one command
nix run home-manager/master -- switch --flake .#dbecerra
```

### Development Operations
```bash
# Update flake inputs
nix flake update

# Check flake validity
nix flake check

# Show what packages would be installed
nix build .#homeConfigurations.dbecerra.activationPackage --dry-run

# Enter development shell with devenv
devenv shell

# Install pre-commit hooks
pre-commit install
```

### Package Management
```bash
# Search for packages
nix search nixpkgs <package-name>

# Show package info
nix show-config
nix flake show
```

## Configuration Structure

### Package Sources
- `nixpkgs`: Unstable channel for latest packages
- `nixpkgs-stable`: 25.05 stable channel for stable packages
- Overlays provide access to both via `unstable.*` and `stable.*` prefixes

### Key Package Categories
- **Languages**: Python 3.11, Go, Node.js 20, Ruby 3.4, Elixir 1.18
- **DevOps**: AWS CLI, Terraform, Terragrunt, Ansible
- **Development**: Neovim, Tmux with oh-my-tmux, Starship prompt
- **Build Tools**: Cargo, Rust compiler (for Mason LSPs)

### Configuration Files
- Tmux configuration sourced from oh-my-tmux input
- Starship uses Catppuccin Mocha color scheme
- Pre-commit hooks cover Terraform, shell scripts, Docker, and security scanning

## Nix Development Patterns

### Adding New Packages
Add packages to the `home.packages` list in `home/dbecerra.nix`. Use `unstable.*` prefix for bleeding-edge versions or `stable.*` for stable versions.

### Modifying Configuration
- Edit `home/dbecerra.nix` for user environment changes
- Edit `flake.nix` for input updates or system-level changes
- Use `home-manager switch` to apply changes

### Troubleshooting
- Check syntax with `nix flake check`
- Use `nix build` with `--dry-run` to preview changes
- Review build logs for dependency conflicts
- Use `nix-collect-garbage` to clean up old generations
