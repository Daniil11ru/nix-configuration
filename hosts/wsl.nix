{ config, lib, pkgs, self, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  time.timeZone = "Europe/Moscow";

  programs.bash = {
    interactiveShellInit = builtins.readFile (self + /scripts/init-bash.sh);
    blesh.enable = true;
  };
  environment.pathsToLink = [ "/share/bash-completion" ];

  programs.zsh = {
    enable = true;

    interactiveShellInit = builtins.readFile (self + /scripts/init-zsh.zsh);

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
