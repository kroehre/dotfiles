#!/usr/bin/env zsh

set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMPDIR="${TMPDIR:-/tmp}"
TEST_HOME="$(mktemp -d "$TMPDIR/dotfiles-mux.XXXXXX")"
BIN_DIR="$TEST_HOME/bin"
LOG_FILE="$TEST_HOME/tmux.log"
PROJECT_DIR="$TEST_HOME/example.project"

trap 'rm -rf "$TEST_HOME"' EXIT

mkdir -p "$BIN_DIR" "$PROJECT_DIR" "$TEST_HOME/.claude" "$TEST_HOME/.codex"

cat > "$BIN_DIR/tmux" <<'EOF'
#!/usr/bin/env zsh
print -r -- "$*" >> "$MUX_TEST_LOG"

if [[ "$*" == *"has-session"* ]]; then
  exit 1
fi

exit 0
EOF
chmod +x "$BIN_DIR/tmux"

cat > "$BIN_DIR/tput" <<'EOF'
#!/usr/bin/env zsh
if [[ "$1" == "cols" ]]; then
  print 120
fi
EOF
chmod +x "$BIN_DIR/tput"

export PATH="$BIN_DIR:$PATH"
export HOME="$TEST_HOME"
export DOTHOME="$ROOT"
export MUX_TEST_LOG="$LOG_FILE"

source "$ROOT/functions/mux"

failures=0

assert_file_contains() {
  local file="$1" expected="$2" message="$3"

  if ! grep -Fq -- "$expected" "$file"; then
    print -u2 -- "FAIL: $message"
    print -u2 -- "Expected to find: $expected"
    print -u2 -- "Actual:"
    sed 's/^/  /' "$file" >&2
    (( failures += 1 ))
  fi
}

assert_status() {
  local actual="$1" expected="$2" message="$3"

  if [[ "$actual" -ne "$expected" ]]; then
    print -u2 -- "FAIL: $message"
    print -u2 -- "Expected status $expected, got $actual"
    (( failures += 1 ))
  fi
}

assert_stderr_contains() {
  local file="$1" expected="$2" message="$3"

  if ! grep -Fq -- "$expected" "$file"; then
    print -u2 -- "FAIL: $message"
    print -u2 -- "Expected stderr to contain: $expected"
    print -u2 -- "Actual stderr:"
    sed 's/^/  /' "$file" >&2
    (( failures += 1 ))
  fi
}

(
  cd "$PROJECT_DIR"
  mux --codex
)
assert_file_contains "$LOG_FILE" "-L mux -f $ROOT/tmux/agent-container.conf new-session -d -s example-project -x120 -y50 $ROOT/codex/mux-codex '$TEST_HOME/.codex/mux-prompt-example-project.md'" "mux --codex starts the Codex wrapper in the outer container"
assert_file_contains "$TEST_HOME/.codex/mux-prompt-example-project.md" "Session name: example-project" "mux --codex writes a Codex prompt with the project session name"

: > "$LOG_FILE"
(
  cd "$PROJECT_DIR"
  mux --claude
)
assert_file_contains "$LOG_FILE" "-L mux -f $ROOT/tmux/agent-container.conf new-session -d -s example-project -x120 -y50 $ROOT/claude/mux-claude '$TEST_HOME/.claude/mux-prompt-example-project.md'" "mux --claude starts the Claude wrapper in the outer container"
assert_file_contains "$TEST_HOME/.claude/mux-prompt-example-project.md" "Session name: example-project" "mux --claude writes a Claude prompt with the project session name"

stderr_file="$TEST_HOME/stderr"
(
  cd "$PROJECT_DIR"
  mux -c
) 2> "$stderr_file"
mux_status=$?
assert_status "$mux_status" 64 "mux -c exits with a usage error"
assert_stderr_contains "$stderr_file" "usage: mux [--claude|--codex] [-K] [dir]" "mux -c prints current flag usage"

if [[ "$failures" -gt 0 ]]; then
  exit 1
fi

print "mux tests passed"
