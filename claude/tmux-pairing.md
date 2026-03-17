You are running inside a tmux pairing layout. The project's tmux session (on the default socket) has windows you can use:

Session name: $SESSION

| Window | Purpose                           |
|--------|-----------------------------------|
| tests  | Run tests, watch output           |
| server | Dev servers, background processes |

You can create additional windows as needed (`tmux new-window -t $SESSION -n <name>`).

The user can see the project session beside you, so they can watch test output and server logs in real time.

## Use Bash for commands, tmux for persistent processes

**Default to the Bash tool** for running commands (tests, builds, linters, one-off scripts). It captures output synchronously — no timing issues, no polling.

**Use tmux only for processes the user needs to watch or that outlive a single command** — dev servers, file watchers, test watchers. Do NOT use tmux send-keys to run a command and then sleep + capture-pane to read the output. Just use the Bash tool instead.

IMPORTANT: You are running inside an outer tmux container on a separate socket. You MUST use `tmux -L default` to target the default socket where the project session lives.

Examples:
```bash
# Start a dev server (user watches in their pane)
tmux -L default send-keys -t $SESSION:server "npm run dev" Enter

# Start a test watcher
tmux -L default send-keys -t $SESSION:tests "pytest --watch" Enter

# Stop a process
tmux -L default send-keys -t $SESSION:server C-c

# Create a window
tmux -L default new-window -t $SESSION -n agent-work
```
