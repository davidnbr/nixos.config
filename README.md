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

Use the shellrc repo alone. Install zsh, tmux, git and starship first (Mac: `brew install zsh tmux zoxide direnv starship`).

```bash
git clone git@github.com:davidnbr/shellrc.git ~/shellrc
~/shellrc/install.sh
```

`install.sh` installs oh-my-zsh and links `~/.zshrc`. It also sets up tmux: it clones oh-my-tmux and the catppuccin plugin at the pinned versions, and links `~/.config/tmux/tmux.conf.local` to `shellrc/tmux/tmux.conf.local`. It moves an existing file to `<name>.bak.<timestamp>`. It never replaces a link that points into `/nix/store`.

On Home Manager machines, `tmux.conf.local` comes from the same shellrc file (`shell/tmux/tmux.conf.local`). Change tmux settings in shellrc only. The oh-my-tmux and catppuccin versions are pinned in `flake.lock` and `home/dbecerra.nix`, and again at the top of `shell/install.sh`. Update both places together.
