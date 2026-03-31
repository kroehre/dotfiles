#!/usr/bin/env bash
# Claude Code status line — general purpose.
# Receives session JSON on stdin, outputs a styled single line.

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "."')

# --- colors ---
reset="\033[0m"
dim="\033[2m"
cyan="\033[36m"
yellow="\033[33m"
red="\033[31m"
fg_bar="\033[38;5;39m"
fg_bar_warn="\033[38;5;208m"
fg_bar_crit="\033[38;5;196m"
fg_bar_bg="\033[38;5;243m"

sep="${dim}│${reset}"

# --- progress bar ---
bar() {
  local pct=$1 width=${2:-6} label=$3
  local filled=$(( pct * width / 100 ))
  local empty=$(( width - filled ))
  local color="$fg_bar"
  if (( pct >= 80 )); then color="$fg_bar_crit"
  elif (( pct >= 60 )); then color="$fg_bar_warn"
  fi
  printf "%b%s" "$dim" "$label"
  printf "%b" "$color"
  for ((i=0; i<filled; i++)); do printf "■"; done
  printf "%b" "$fg_bar_bg"
  for ((i=0; i<empty; i++)); do printf "□"; done
  printf "%b" "$reset"
}

# --- git branch + dirty ---
branch=""
dirty=""
if git_branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null); then
  branch="$git_branch"
  if ! git -C "$cwd" diff --quiet 2>/dev/null || ! git -C "$cwd" diff --cached --quiet 2>/dev/null; then
    dirty="*"
  fi
fi

# --- data from JSON ---
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
rate_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0' | cut -d. -f1)

# --- assemble ---
printf " "
bar "$ctx_pct" 8 "C "
if [ "$rate_pct" -gt 0 ] 2>/dev/null; then
  printf " "
  bar "$rate_pct" 8 "R "
fi
if [ -n "$branch" ]; then
  printf " %b %b%s%b" "$sep" "$yellow" "$branch" "$reset"
  [ -n "$dirty" ] && printf "%b%s%b" "$red" "$dirty" "$reset"
fi
printf "\n"
