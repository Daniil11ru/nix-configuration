{ config, pkgs, lib, catppuccin, self, ... }:
{
  imports = [
    catppuccin.homeModules.catppuccin
  ];

  services.ssh-agent.enable = true; 

  sops = {
    age.keyFile = "/home/nixos/.config/sops/age/keys.txt";
    secrets."ssh/id_ed25519_github" = {
      format = "binary";
      sopsFile = self + "/ssh/private/id_ed25519_github.sops";
    };
    secrets."ssh/id_ed25519_gitea" = {
      format = "binary";
      sopsFile = self + "/ssh/private/id_ed25519_gitea.sops";
    };
  };

  home.activation.ensureSshDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    install -d -m 700 "$HOME/.ssh"
  '';

  home.file.".ssh/id_ed25519_github.pub" = {
    source = self + "/ssh/public/id_ed25519_github.pub";
  };
  home.file.".ssh/id_ed25519_gitea.pub" = {
    source = self + "/ssh/public/id_ed25519_gitea.pub";
  };

  home.stateVersion = "25.05";

  home.shellAliases = {
    cat = "bat";

    find = "fd";

    grep = "rg";
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
    zsh-syntax-highlighting.enable = true;
    delta.enable = true;
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

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        user = "git";
        identitiesOnly = true;
        identityFile = config.sops.secrets."ssh/id_ed25519_github".path;
      };
      "git.komictf.ru" = {
        user = "git";
        identitiesOnly = true;
        identityFile = config.sops.secrets."ssh/id_ed25519_gitea".path;
      };
    };
  };

  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.fzf.enable = true;
  programs.bat.enable = true;
  programs.lazygit.enable = true;
  programs.fastfetch.enable = true;
}
