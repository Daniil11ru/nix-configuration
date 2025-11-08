{ config, lib, pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  time.timeZone = "Europe/Moscow";

  programs.bash = {
    blesh.enable = true;
  };
  environment.pathsToLink = [ "/share/bash-completion" ];

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    enableBashCompletion = true;
    autosuggestions = {
      enable = true;
      highlightStyle = "fg=#8a8a8a";
      strategy = [ "history" "completion" ];
      async = true;
    };

    syntaxHighlighting.enable = true;
    syntaxHighlighting.highlighters = [
      "main"
      "brackets"
    ];
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
