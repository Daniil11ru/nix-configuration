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

  # Для возможности использования VS Code Remote
  programs.nix-ld.enable = true;

  # Настроить можно только в системной конфигурации
  programs.fzf = {
    keybindings = true;
    fuzzyCompletion = true;
  };

  system.stateVersion = "25.05";
}
