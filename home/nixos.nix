{ config, pkgs, ... }:
{
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    fzf
    lsd
    bat
    micro
    lazydocker
    lazygit
    tldr
    fd
    gping
    doggo
    dust
    duf
    lazysql
    lazyjournal
    posting
    frogmouth
    glow
    ripgrep
    fastfetch
    thefuck
    gittype
    sops
    age
    python314
  ];

  programs.git.enable = true;
  programs.fzf.enable = true;

  home.file.".gitconfig".text = ''
    [core]
      editor = micro
  '';
}
