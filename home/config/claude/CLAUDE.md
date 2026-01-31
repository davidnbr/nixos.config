# Token Optimization Guidelines

- **Be Concise**: Provide short, direct answers. Avoid conversational filler.
- **Code Changes**: When suggesting code, only show the relevant parts or the changed function. Do not reproduce entire files unless necessary.
- **Context**: Do not read large lock files or dependency directories unless explicitly asked.
- **Memory**: Use the memory tool to recall context instead of re-reading files repeatedly.

# Agent Orchestration

- **Lead**: `principal-software-engineer` triages requests and delegates to specialists.
- **Workflows**: Follow "Design → Implement → Review" patterns in `agents/agent-orchestration.md`.
- **Quality**: All changes must pass a `code-reviewer` gate before completion.

