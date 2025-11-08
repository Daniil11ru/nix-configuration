{ config, pkgs, ... }:
{
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
  	wget
    micro
    lazydocker
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
    sops
    age
    python314
  ];

  programs.git = {
    enable = true;
    userName  = "Daniil Miroshnik";
    userEmail = "daniilmiroshnik11062001@gmail.com";
  };

  programs.fzf.enable = true;
  programs.lsd.enable = true;
  programs.bat.enable = true;
  programs.lazygit.enable = true;
  programs.fastfetch.enable = true;

  home.file.".gitconfig".text = ''
    [core]
      editor = micro
  '';
}
