#! bash oh-my-bash.module
# aws.plugin.sh
# Author: Michael Anckaert <michael.anckaert@sinax.be>
# Based on oh-my-zsh AWS plugin
#
# command 'agp' returns the selected AWS profile (aws get profile)
# command 'asp' sets the AWS profile to use (aws set profile)
#

export AWS_HOME=~/.aws

function asp {
  local rprompt=${RPROMPT/<aws:$(agp)>/}

  export AWS_DEFAULT_PROFILE=$1
  export AWS_PROFILE=$1
}
#! bash oh-my-bash.module
#------------------------------------------------------------------------------
# Note on copyright (2022-08-23): The aliases defined in this file seems to
# originally come from a blog post [1].  See also the comments in lib/base.sh.
#
# [1] Nathaniel Landau, "My Mac OSX Bash Profile",
#     https://natelandau.com/my-mac-osx-bash_profile/, 2013-07-02.
#
#------------------------------------------------------------------------------
#  Description:  This file holds all general BASH aliases
#
#  For your own benefit, we won't load all aliases in the general, we will
#  keep the very generic command here and enough for daily basis tasks.
#
#  If you are looking for the more sexier aliases, we suggest you take a look
#  into other core alias files which installed by default.
#
#------------------------------------------------------------------------------

#   -----------------------------
#   1.  MAKE TERMINAL BETTER
#   -----------------------------

# Preferred 'cp' implementation.  Determines the use of the option `-v' on the
# first call Ref. https://github.com/ohmybash/oh-my-bash/issues/351

alias ll='ls -lAFh'                              # Preferred 'ls' implementation
alias less='less -FSRXc'                         # Preferred 'less' implementation
alias wget='wget -c'                             # Preferred 'wget' implementation (resume download)
alias c='clear'                                  # c:            Clear terminal display
alias path='echo -e ${PATH//:/\\n}'              # path:         Echo all executable Paths
alias show_options='shopt'                       # Show_options: display bash options settings
alias fix_stty='stty sane'                       # fix_stty:     Restore terminal settings when screwed up
alias fix_term='echo -e "\033c"'                 # fix_term:     Reset the conosle.  Similar to the reset command
alias cic='bind "set completion-ignore-case on"' # cic:          Make tab-completion case-insensitive
alias src='source ~/.bashrc'                     # src:          Reload .bashrc file
#! bash oh-my-bash.module
# aws.plugin.sh
# Author: Michael Anckaert <michael.anckaert@sinax.be>
# Based on oh-my-zsh AWS plugin
#
# command 'agp' returns the selected AWS profile (aws get profile)
# command 'asp' sets the AWS profile to use (aws set profile)
#

export AWS_HOME=~/.aws

function asp {
  local rprompt=${RPROMPT/<aws:$(agp)>/}

  export AWS_DEFAULT_PROFILE=$1
  export AWS_PROFILE=$1
}
#! bash oh-my-bash.module

#
# Functions
#

# The name of the current branch
# Back-compatibility wrapper for when this function was defined here in
# the plugin, before being pulled in to core lib/git.zsh as git_current_branch()
# to fix the core -> git plugin dependency.
function current_branch() {
  git_current_branch
}
#
# Aliases
#
# From Oh-My-Zsh:
# https://github.com/ohmyzsh/ohmyzsh/blob/f36c6db0eac17b022eee87411e6996a5f5fc8457/plugins/git/git.plugin.zsh
#

alias g='command git'

alias ga='command git add'
alias gaa='command git add --all'
alias gapa='command git add --patch'
alias gau='command git add --update'
alias gav='command git add --verbose'
alias gwip='command git add -A; command git rm $(git ls-files --deleted) 2> /dev/null; command git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'

alias gam='command git am'
alias gama='command git am --abort'
alias gamc='command git am --continue'
alias gamscp='command git am --show-current-patch'
alias gams='command git am --skip'

alias gap='command git apply'
alias gapt='command git apply --3way'

alias gbl='command git blame -b -w'

alias gb='command git branch'
alias gbD='command git branch --delete --force'
alias gba='command git branch -a'
alias gbd='command git branch -d'
alias gbda='command git branch --no-color --merged | command grep -vE "^([+*]|\s*($(git_main_branch)|$(git_develop_branch))\s*$)" | command xargs git branch --delete 2>/dev/null'
alias gbg='LANG=C command git branch -vv | grep ": gone\]"'
alias gbgD='LANG=C command git branch --no-color -vv | grep ": gone\]" | awk '"'"'{print $1}'"'"' | command xargs git branch -D'
alias gbgd='LANG=C command git branch --no-color -vv | grep ": gone\]" | awk '"'"'{print $1}'"'"' | command xargs git branch -d'
alias gbm='command git branch --move'
alias gbnm='command git branch --no-merged'
alias gbr='command git branch --remote'
alias gbsc='command git branch --show-current'
alias ggsup='command git branch --set-upstream-to="origin/$(git_current_branch)"'

alias gbs='command git bisect'
alias gbsb='command git bisect bad'
alias gbsg='command git bisect good'
alias gbsn='command git bisect new'
alias gbso='command git bisect old'
alias gbsr='command git bisect reset'
alias gbss='command git bisect start'

alias gcb='command git checkout -b'
alias gcd='command git checkout "$(git_develop_branch)"'
alias gcm='command git checkout "$(git_main_branch)"'
alias gco='command git checkout'
alias gcor='command git checkout --recurse-submodules'

alias gcp='command git cherry-pick'
alias gcpa='command git cherry-pick --abort'
alias gcpc='command git cherry-pick --continue'
alias gcps='command git cherry-pick -s'

alias gcl='command git clone --recursive'
function gccd() {
  command git clone --recurse-submodules "$@"
  local lastarg=$_
  [[ -d $lastarg ]] && cd "$lastarg" && return
  lastarg=${lastarg##*/}
  cd "${lastarg%.git}"
}
#compdef _git gccd=git-clone

alias gclean='command git clean -fd'

alias gc!='command git commit --verbose --amend'
alias gc='command git commit --verbose'
alias gca!='command git commit --verbose --all --amend'
alias gca='command git commit --verbose --all'
alias gcam='command git commit --all --message'
alias gcan!='command git commit --verbose --all --no-edit --amend'
alias gcans!='command git commit --verbose --all --signoff --no-edit --amend'
alias gcas='command git commit --all --signoff'
alias gcasm='command git commit --all --signoff --message'
alias gcmsg='command git commit --message'
alias gcn!='command git commit --verbose --no-edit --amend'
alias gcs='command git commit --gpg-sign'
alias gcsm='command git commit --signoff --message'
alias gcss='command git commit --gpg-sign --signoff'
alias gcssm='command git commit --gpg-sign --signoff --message'

alias gcf='command git config --list'

alias gdct='command git describe --tags `git rev-list --tags --max-count=1`'

alias gd='command git diff'
alias gdca='command git diff --cached'
alias gdcw='command git diff --cached --word-diff'
alias gds='command git diff --staged'
alias gdw='command git diff --word-diff'
alias gdup='command git diff @{upstream}'
function gdnolock() {
  command git diff "$@" ":(exclude)package-lock.json" ":(exclude)*.lock"
}
#compdef _git gdnolock=git-diff
function gdv {
  command git diff -w "$@" | view -
}
#compdef _git gdv=git-diff

alias gdt='command git diff-tree --no-commit-id --name-only -r'

alias gdtool='command git difftool -d'

alias gf='command git fetch'
alias gfa='command git fetch --all --prune'
alias gfo='command git fetch origin'
# jobs=<n> was added in git 2.8
# alias gfa='git fetch --all --prune --jobs=10' \

alias gg='command git gui citool'
alias gga='command git gui citool --amend'

alias ghh='command git help'

alias glg='command git log --stat'
alias glgg='command git log --graph'
alias glgga='command git log --graph --decorate --all'
alias glgm='command git log --graph --max-count=10'
alias glgp='command git log --stat -p'
alias glo='command git log --oneline --decorate'
alias glod='command git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'
alias glods='command git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short'
alias glog='command git log --oneline --decorate --graph'
alias gloga='command git log --oneline --decorate --graph --all'
alias glol='command git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias glola='command git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
alias glols='command git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'
# Pretty log messages
function _git_log_prettily() {
  if [[ $1 ]]; then
    command git log --pretty="$1"
  fi
}
alias glp='_git_log_prettily'
#compdef _git glp=git-log

alias gignored='command git ls-files -v | grep "^[[:lower:]]"'
alias gfg='command git ls-files | grep'

alias gm='command git merge'
alias gma='command git merge --abort'
alias gmom='command git merge "origin/$(git_main_branch)"'
alias gms='command git merge --squash'
alias gmum='command git merge "upstream/$(git_main_branch)"'

alias gmt='command git mergetool --no-prompt'                   # deprecate?
alias gmtvim='command git mergetool --no-prompt --tool=vimdiff' # deprecate?
alias gmtl='command git mergetool --no-prompt'
alias gmtlvim='command git mergetool --no-prompt --tool=vimdiff'

alias ggpull='command git pull origin "$(git_current_branch)"'
alias ggpur='ggu'
alias gl='command git pull'
alias gluc='command git pull upstream "$(git_current_branch)"'
alias glum='command git pull upstream "$(git_main_branch)"'
alias gpr='command git pull --rebase'
alias gup='command git pull --rebase'
alias gupa='command git pull --rebase --autostash'
alias gupav='command git pull --rebase --autostash --verbose'
alias gupom='command git pull --rebase origin "$(git_main_branch)"'
alias gupomi='command git pull --rebase=interactive origin "$(git_main_branch)"'
alias gupv='command git pull --rebase --verbose'
function ggl {
  if (($# != 0 && $# != 1)); then
    command git pull origin "$*"
  else
    local b=
    (($# == 0)) && b=$(git_current_branch)
    command git pull origin "${b:-$1}"
  fi
}
function ggu {
  local b=
  (($# != 1)) && b=$(git_current_branch)
  command git pull --rebase origin "${b:-$1}"
}
#compdef _git ggl=git-checkout
#compdef _git ggpull=git-checkout
#compdef _git ggpur=git-checkout
#compdef _git ggu=git-checkout

alias ggpush='command git push origin "$(git_current_branch)"'
alias gp='command git push'
alias gpd='command git push --dry-run'
alias gpf!='command git push --force'
alias gpf='command git push --force-with-lease'
alias gpoat='command git push origin --all && command git push origin --tags'
alias gpod='command git push origin --delete'
alias gpsup='command git push --set-upstream origin "$(git_current_branch)"'
alias gpsupf='command git push --set-upstream origin "$(git_current_branch)" --force-with-lease'
alias gpu='command git push upstream'
alias gpv='command git push --verbose'
#is-at-least 2.30 "$git_version" && alias gpf='git push --force-with-lease --force-if-includes'
#is-at-least 2.30 "$git_version" && alias gpsupf='git push --set-upstream origin "$(git_current_branch)" --force-with-lease --force-if-includes'
function ggf {
  (($# != 1)) && local b=$(git_current_branch)
  command git push --force origin "${b:=$1}"
}
function ggfl {
  (($# != 1)) && local b=$(git_current_branch)
  command git push --force-with-lease origin "${b:=$1}"
}
function ggp {
  if (($# != 0 && $# != 1)); then
    command git push origin "$*"
  else
    (($# == 0)) && local b=$(git_current_branch)
    command git push origin "${b:=$1}"
  fi
}
function ggpnp {
  if (($# == 0)); then
    ggl && ggp
  else
    ggl "$*" && ggp "$*"
  fi
}
#compdef _git ggf=git-checkout
#compdef _git ggfl=git-checkout
#compdef _git ggp=git-checkout
#compdef _git ggpnp=git-checkout
#compdef _git ggpush=git-checkout
#compdef _git gpoat=git-push

alias grb='command git rebase'
# grb _git_rebase
alias grba='command git rebase --abort'
# grba _git_rebase
alias grbc='command git rebase --continue'
# grbc _git_rebase
alias grbi='command git rebase --interactive'
# grbi _git_rebase
alias grbo='command git rebase --onto'
# grbo _git_rebase
alias grbs='command git rebase --skip'
# grbs _git_rebase
alias grbd='command git rebase "$(git_develop_branch)"'
# grbd _git_rebase
alias grbm='command git rebase "$(git_main_branch)"'
# grbm _git_rebase
alias grbom='command git rebase "origin/$(git_main_branch)"'
# grbom _git_rebase

alias gr='command git remote'
# gr _git_remote
alias gra='command git remote add'
# gra _git_remote
alias grmv='command git remote rename'
# grmv _git_remote
alias grrm='command git remote remove'
# grrm _git_remote
alias grset='command git remote set-url'
# grset _git_remote
alias grup='command git remote update'
# grup _git_remote
alias grv='command git remote --verbose'
# grv _git_remote

alias gpristine='command git reset --hard && command git clean --force -dfx'
alias grh='command git reset'
# grh _git_reset
alias grhh='command git reset --hard'
# grhh _git_reset
alias grhk='command git reset --keep'
# grhk _git_reset
alias grhs='command git reset --soft'
# grhs _git_reset
alias groh='command git reset "origin/$(git_current_branch)" --hard'
# groh _git_reset
alias grt='cd $(command git rev-parse --show-toplevel || _omb_util_print ".")'
alias gru='command git reset --'
# gru _git_reset

alias grs='command git restore'
# grs _git_restore
alias grss='command git restore --source'
# grss _git_restore
alias grst='command git restore --staged'
# grst _git_restore

alias gunwip='command git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && command git reset HEAD~1'
alias grev='command git revert'
# grev _git_revert

alias grm='command git rm'
# grm _git_rm
alias grmc='command git rm --cached'
# grmc _git_rm

alias gcount='command git shortlog --summary --numbered'
# gcount _git_shortlog
#compdef _git gcount complete -F _git gcount

alias gsh='command git show'
# gsh _git_show
alias gsps='command git show --pretty=short --show-signature'
# gsps _git_show

alias gsta='command git stash save'
# gsta _git_stash
alias gstaa='command git stash apply'
# gstaa _git_stash
alias gstall='command git stash --all'
# gstall _git_stash
alias gstc='command git stash clear'
# gstc _git_stash
alias gstd='command git stash drop'
# gstd _git_stash
alias gstl='command git stash list'
# gstl _git_stash
alias gstp='command git stash pop'
# gstp _git_stash
alias gsts='command git stash show'
# gsts _git_stash
alias gstu='gsta --include-untracked'
# gstu _git_stash
#is-at-least 2.13 "$git_version" && alias gsta='command git stash push'

alias gsb='command git status --short --branch'
# gsb _git_status
alias gss='command git status --short'
# gss _git_status
alias gst='command git status'
# gst _git_status

alias gsi='command git submodule init'
# gsi _git_submodule
alias gsu='command git submodule update'
# gsu _git_submodule

alias git-svn-dcommit-push='command git svn dcommit && command git push github "$(git_main_branch):svntrunk"'
alias gsd='command git svn dcommit'
# gsd _git_svn
alias gsr='command git svn rebase'
# gsr _git_svn
#compdef _git git-svn-dcommit-push=git

alias gsw='command git switch'
# gsw _git_switch
alias gswc='command git switch --create'
# gswc _git_switch
alias gswd='command git switch "$(git_develop_branch)"'
# gswd _git_switch
alias gswm='command git switch "$(git_main_branch)"'
# gswm _git_switch

alias gta='command git tag --annotate'
# gta _git_tag
alias gts='command git tag --sign'
# gts _git_tag
alias gtv='command git tag | sort -V'
# gtv _git_tag
function gtl {
  command git tag --sort=-v:refname -n --list "$1*"
}
# gtl _git_tag
#compdef _git gtl=git-tag

alias gignore='command git update-index --assume-unchanged'
alias gunignore='command git update-index --no-assume-unchanged'

alias gwch='command git whatchanged -p --abbrev-commit --pretty=medium'
# gwch _git_whatchanged

alias gwt='command git worktree'
# gwt _git_worktree
alias gwta='command git worktree add'
# gwta _git_worktree
alias gwtls='command git worktree list'
# gwtls _git_worktree
alias gwtmv='command git worktree move'
# gwtmv _git_worktree
alias gwtrm='command git worktree remove'
# gwtrm _git_worktree

alias gk='\gitk --all --branches'
alias gke='\gitk --all $(git log --walk-reflogs --pretty=%h)'
# alias gk='\gitk --all --branches &!'
# alias gke='\gitk --all $(git log --walk-reflogs --pretty=%h) &!'
#compdef _git gk='command gitk'
#compdef _git gke='command gitk'
# Aliases
# (sorted alphabetically)
#

alias t='terraform'

alias tapply='terraform apply'
alias tfmt='terraform fmt'
alias tinit='terraform init'
alias tplan='terraform plan'
#! bash oh-my-bash.module
# @chopnico 2021
#
# tmux-autoattach.plugin.sh
#
# A tmux plugin that will automatically attach itself to a bash session.

[ -z "$OSH_PLUGIN_TMUX_AUTOATTACH_BEHAVIOR" ] && OSH_PLUGIN_TMUX_AUTOATTACH_BEHAVIOR="detach"

# Note on the option "-As0": tmux-3.0a and before does not attach to a session
# as far as the session name is not given by "-s SESSION_NAME" [1].  From
# tmux-3.1, it attaches to an existing session, if any, without specifying the
# session.  Here, we assume the session name to be "0", which is the default
# name for the first session.
#
# [1] https://github.com/ohmybash/oh-my-bash/pull/332

function _osh_plugin_tmux_autoattach_exit {
  [ -z "$TMUX" ] && tmux -2u new -As0 && exit
}

function _osh_plugin_tmux_autoattach_detach {
  [ -z "$TMUX" ] && tmux -2u new -As0
}

case "$OSH_PLUGIN_TMUX_AUTOATTACH_BEHAVIOR" in
"exit")
  _osh_plugin_tmux_autoattach_exit
  ;;
"detach" | *)
  _osh_plugin_tmux_autoattach_detach
  ;;
esac
