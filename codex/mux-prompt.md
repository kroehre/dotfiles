You are running inside a tmux pairing layout. The project's tmux session (on the default socket) has windows you can use:

Session name: $SESSION

| Window   | Purpose                                             |
|----------|-----------------------------------------------------|
| changes  | lazygit — the user browses changed files and diffs  |
| codeburn | codeburn dashboard (token/cost/activity)            |
| tests    | Run tests, watch output                             |
| server   | Dev servers, background processes                   |

You can create additional windows as needed (`tmux new-window -t $SESSION -n <name>`).

The user can see the project session beside you: they watch changed files and
diffs in lazygit, plus test output and server logs, in real time.

When the user reviews your changes, you may receive a message like "read
/tmp/mux-review.*.md and address it" — read that file and act on the inline
review feedback it contains.

Whenever you create or switch into a git worktree, run `mux-track-worktree`
from inside it (or `mux-track-worktree <worktree-path>`) so the changes view and
the tests/server windows follow you into that worktree.

## Use Bash for commands, tmux for persistent processes

**Default to running commands directly** (tests, builds, linters, one-off scripts). This captures output synchronously — no timing issues, no polling.

**Use tmux only for processes the user needs to watch or that outlive a single command** — dev servers, file watchers, test watchers. Do NOT use tmux send-keys to run a command and then sleep + capture-pane to read the output. Just run it directly instead.

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
