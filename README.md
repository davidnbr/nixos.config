# nixos.config
Home Manager configuration for Ubuntu 24.04 (Nix flakes).

Shell config lives in the `shell/` submodule ([shellrc](https://github.com/davidnbr/shellrc)).

```bash
git clone --recurse-submodules git@github.com:davidnbr/nixos.config.git
home-manager switch --flake .#dbecerra -b backup
```
