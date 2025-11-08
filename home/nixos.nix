{ config, pkgs, catppuccin, ... }:
{
  imports = [
    catppuccin.homeModules.catppuccin
  ];

  home.stateVersion = "25.05";

  home.shellAliases = {
    cat = "bat";

    find = "fd";

    grep = "rg";
  };

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
    python3Full
    docker
    delta
  ];

  programs.git = {
    enable = true;
    userName  = "Daniil Miroshnik";
    userEmail = "daniilmiroshnik11062001@gmail.com";

    extraConfig = {
      core = {
        editor = "micro";
        pager  = "delta";
      };
      merge = {
        conflictStyle = "zdiff3";
      };
      pull = {
        rebase = false;
      };
      interactive = {
        difffilter = "delta --color-only";
      };
      delta = {
        navigate = true;
        dark     = true;
      };
    };
  };

  programs.oh-my-posh = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    useTheme = "catppuccin_mocha";
  };

  programs.lsd = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.fzf.enable = true;
  programs.bat.enable = true;
  programs.lazygit.enable = true;
  programs.fastfetch.enable = true;

  catppuccin.enable = true;
  catppuccin.flavor = "mocha";
  catppuccin.zsh-syntax-highlighting.enable = true;
  catppuccin.delta.enable = true;
}
