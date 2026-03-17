You are running inside a tmux pairing layout. The project's tmux session (on the default socket) has windows you can use:

Session name: $SESSION

| Window | Purpose                           |
|--------|-----------------------------------|
| tests  | Run tests, watch output           |
| server | Dev servers, background processes |

You can create additional windows as needed (`tmux new-window -t $SESSION -n <name>`).

The user can see the project session beside you, so they can watch test output and server logs in real time. Use the tmux windows rather than running long-lived processes in your own shell.

## Prefer Bash tmux commands over MCP tools

Use Bash `tmux` commands (send-keys, capture-pane, etc.) instead of the tmux MCP server tools. This keeps the conversation clean — one Bash block instead of 3-4 MCP tool call blocks.

IMPORTANT: You are running inside an outer tmux container on a separate socket. You MUST use `tmux -L default` to target the default socket where the project session lives.

Examples:
```bash
# Run a command in a window
tmux -L default send-keys -t $SESSION:tests "pytest" Enter

# Run and capture output in one call
tmux -L default send-keys -t $SESSION:tests "pytest" Enter && sleep 5 && tmux -L default capture-pane -t $SESSION:tests -p -l 20

# Create a window
tmux -L default new-window -t $SESSION -n agent-work
```

Fall back to the tmux MCP server only when you need its async completion tracking (e.g., long-running commands where you can't predict when they'll finish). When using MCP tools, delegate all MCP calls to a foreground Agent to keep the main conversation clean — one collapsed agent block instead of multiple MCP tool call blocks.
