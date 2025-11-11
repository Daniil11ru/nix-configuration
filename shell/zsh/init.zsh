if [[ -r ~/.bash_history ]] && (( ! ${+_BASH_HISTORY_IMPORTED} )); then
  fc -RI ~/.bash_history 2>/dev/null || true
  typeset -g _BASH_HISTORY_IMPORTED=1
fi

setopt INC_APPEND_HISTORY EXTENDED_HISTORY