shopt -s histappend
pc_snippet='history -a; history -r'
if [[ $PROMPT_COMMAND != *"$pc_snippet"* ]]; then
  if [[ -n "$PROMPT_COMMAND" ]]; then
    PROMPT_COMMAND="$pc_snippet; $PROMPT_COMMAND"
  else
    PROMPT_COMMAND="$pc_snippet"
  fi
fi
