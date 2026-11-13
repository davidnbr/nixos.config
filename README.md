# nixos.config
Home Manager configuration for Ubuntu 24.04 (Nix flakes).

Shell config lives in the `shell/` submodule ([shellrc](https://github.com/davidnbr/shellrc)). The shell is zsh with oh-my-zsh. The prompt is starship (`shell/starship.toml`).

## Setup

```bash
git clone --recurse-submodules git@github.com:davidnbr/nixos.config.git
cd nixos.config
sudo apt install zsh
home-manager switch --flake .#dbecerra -b backup
~/.config/shellrc/install.sh --omz-only
chsh -s "$(which zsh)"
```

Home Manager links `~/.zshrc`. `install.sh --omz-only` installs oh-my-zsh only. Log out and in again after `chsh`.

Machine-specific shell lines go in `home/config/shell.local.sh`. Home Manager links it to `~/.config/shell/local.sh`.

## Other machines (WSL2 Ubuntu, Mac)

Use the shellrc repo alone. Install zsh and starship first (Mac: `brew install zsh zoxide direnv starship`).

```bash
git clone git@github.com:davidnbr/shellrc.git ~/shellrc
~/shellrc/install.sh
```

`install.sh` installs oh-my-zsh and links `~/.zshrc`. It moves an existing `~/.zshrc` to `~/.zshrc.bak.<timestamp>`.
