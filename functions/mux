mux() {
  local name cols
  if [ -n "$1" ]; then
    cd $1
  fi
  name="$(basename $PWD | sed -e 's/\./-/g')"
  cols="$(tput cols)"
  if ! $(tmux has-session -t $name &>/dev/null); then
    tmux new-session -d -n code -s $name -x${cols-150} -y50 && \
      tmux new-window -a -d -n tests -t $name:0 \; \
      new-window -a -d -n server -t $name:1 \; \
      select-layout -t $name main-vertical &>/dev/null
  fi
  tmux attach-session -t $name
}
