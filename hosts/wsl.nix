{ config, lib, pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  time.timeZone = "Europe/Moscow";

  programs.bash = {
    interactiveShellInit = ''
      shopt -s histappend
      pc_snippet='history -a; history -r'
      if [[ $PROMPT_COMMAND != *"$pc_snippet"* ]]; then
        if [[ -n "$PROMPT_COMMAND" ]]; then
          PROMPT_COMMAND="$pc_snippet; $PROMPT_COMMAND"
        else
          PROMPT_COMMAND="$pc_snippet"
        fi
      fi
    '';

    blesh.enable = true;
  };
  environment.pathsToLink = [ "/share/bash-completion" ];

  programs.zsh = {
    enable = true;

    interactiveShellInit = ''
      if [[ -r ~/.bash_history ]] && (( ! ''${+_BASH_HISTORY_IMPORTED} )); then
        fc -RI ~/.bash_history 2>/dev/null || true
        typeset -g _BASH_HISTORY_IMPORTED=1
      fi

      setopt INC_APPEND_HISTORY EXTENDED_HISTORY
    '';

    enableCompletion = true;
    enableBashCompletion = true;
    autosuggestions = {
      enable = true;
      strategy = [ "history" "completion" ];
      async = true;
    };

    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
        "pattern"
      ];
    };
  };
  
  users.users.nixos.shell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  # Для возможности использования VS Code Remote
  programs.nix-ld.enable = true;

  # Настроить можно только в системной конфигурации
  programs.fzf = {
    keybindings = true;
    fuzzyCompletion = true;
  };

  system.stateVersion = "25.05";
}
