if [[ -r ~/.bash_history ]] && (( ! ${+_BASH_HISTORY_IMPORTED} )); then
  fc -RI ~/.bash_history 2>/dev/null || true
  typeset -g _BASH_HISTORY_IMPORTED=1
fi

if [[ -n $IN_NIX_SHELL ]]; then
  export SHELL=/run/current-system/sw/bin/zsh
fi

setopt INC_APPEND_HISTORY EXTENDED_HISTORY