# Machine-specific shell settings. Linked to ~/.config/shell/local.sh and sourced by the shared zshrc.
_local_path_add() { [ -d "$1" ] && PATH="$1:$PATH"; }

_local_path_add "$HOME/.amplify/bin"
_local_path_append_pub() { [ -d "$HOME/.pub-cache/bin" ] && PATH="$PATH:$HOME/.pub-cache/bin"; }
_local_path_append_pub
_local_path_add "$HOME/.claude-code-templates/bin"
_local_path_add "$HOME/.local/bin/claude"
_local_path_add "$HOME/.opencode/bin"
export PATH
unset -f _local_path_add _local_path_append_pub

alias claude-mem='bun "$HOME/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs"'

# shellcheck source=/dev/null
[ -r "$HOME/.openclaw/completions/openclaw.zsh" ] && . "$HOME/.openclaw/completions/openclaw.zsh"

# For terraform-local
alias localstack-start='docker run -d -p 4566:4566 -p 4571:4571 --name localstack localstack/localstack'
alias localstack-stop='docker stop localstack && docker rm localstack'
alias localstack-logs='docker logs -f localstack'
