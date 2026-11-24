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

`install.sh` installs oh-my-zsh and links `~/.zshrc`. It also sets up these parts:
- tmux: it clones oh-my-tmux and the catppuccin plugin at the pinned versions, and links `~/.config/tmux/tmux.conf.local`.
- nvim: it links the files in `shellrc/nvim` into `~/.config/nvim`. The first nvim start installs LazyVim and the plugins. LazyVim needs Neovim 0.11.2 or newer, git, a C compiler and network access. Ubuntu 24.04 apt has Neovim 0.9.5, so install a newer release by hand.
- pre-commit: it links the shared config to `~/.config/pre-commit/pre-commit-config.yaml`.

It moves an existing file to `<name>.bak.<timestamp>`. It never replaces a link that points into `/nix/store`. At the end it prints the installed and missing tools and the next steps (git, hooks, ssh).

```bash
~/shellrc/install.sh --check      # report only, changes nothing
~/shellrc/install.sh --tools y    # also install helper tools with apt or brew
```

`--tools y` installs `git-delta fzf bat fd-find ripgrep shellcheck jq build-essential unzip curl` with apt, or `git-delta fzf bat ripgrep fd shellcheck jq` with brew. Node, cargo and the claude CLI stay manual.

## Windows (PowerShell 5.1 or 7, and psmux)

Use the shellrc repo alone, in a Windows folder. Run these in Windows PowerShell 5.1 or PowerShell 7. Windows PowerShell 5.1 needs an execution policy that allows local scripts, for example `RemoteSigned`.

```powershell
git clone git@github.com:davidnbr/shellrc.git $HOME\shellrc
& $HOME\shellrc\windows\install-windows.ps1 -Tools
```

`install-windows.ps1` copies the shared files. It never links them, so run it again after a change in shellrc:
- `pre-commit-config.yaml`, `git/` and the `nvim` files go to `~/.config`. `starship.toml` goes there too, but with `git_commit`, `git_status` and `git_state` off. Starting processes is slow on Windows, and these modules cost about 700 ms per prompt in a repo. The branch name still shows. Edit the shared `starship.toml` only. It sets the user variable `XDG_CONFIG_HOME` so that Neovim uses `~/.config/nvim`, as on Linux.
- psmux: it writes `~/.psmux.conf` from the plain tmux lines in `tmux/tmux.conf.local` and clones catppuccin at the pinned version. psmux does not expand `#{d:current_file}`, so the installer replaces it with the folder of each file in that clone. A clone without the token stays unchanged. Edit `tmux.conf.local` only.
- PowerShell: `windows/profile.ps1` holds the aliases and tool hooks. It does not change PATH or the built-in PowerShell aliases. Seven git aliases clash with built-ins, so they get a `w` suffix: `gcbw` `gcw` `gcmw` `glw` `gmw` `gpw` `gpvw`. The installer report lists any profile function that an alias hides (`shadowed:` line). `$PROFILE` loads it, and each PowerShell version has its own `$PROFILE`, so run the installer once in each. The direnv hook loads only in PowerShell 7.2 or newer. Keep it in step with `lib/aliases.sh` and `lib/terraform.sh`.
- `lazyvim.json` and `lazy-lock.json` are copied only when missing, because nvim writes them. Copy them back to shellrc by hand before you commit.

`-Tools` installs the helper tools with winget. `-Check` reports only. A file that differs moves to `<name>.bak.<timestamp>`.

On Home Manager machines, the same shellrc files are used:
- `tmux.conf.local`, `nvim/*` (except the two files below) and `pre-commit-config.yaml` are linked from the store.
- `lazyvim.json` and `lazy-lock.json` are linked to the writable files in `~/nixos.config/shell/nvim/`, because nvim writes them. After `:LazyExtras` or `:Lazy update`, commit the change in shellrc, then bump the submodule here. The links break if the repo moves from `~/nixos.config`.
- Git settings stay in `home/dbecerra.nix`. `shell/git/gitconfig` holds the same values for machines without Home Manager.

Change tmux, nvim and pre-commit settings in shellrc only. The oh-my-tmux and catppuccin versions are pinned in `flake.lock`, `home/dbecerra.nix` and at the top of `shell/install.sh`. Update all places together.
