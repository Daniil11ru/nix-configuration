{ config, pkgs, pkgsUnstable, lib, catppuccin, self, ... }:
{
  imports = [
    catppuccin.homeModules.catppuccin
    ../modules/kubernetes.nix
    ../modules/ansible.nix
    ../modules/frontend.nix
  ];

  my.kubernetes.enable = true;
  my.ansible.enable = true;
  my.frontend.enable = true;

  services.ssh-agent.enable = true; 

  sops = {
    age.keyFile = "/home/nixos/.config/sops/age/keys.txt";
    secrets."ssh/id_ed25519_github" = {
      format = "binary";
      sopsFile = self + "/files/ssh/private/id_ed25519_github.sops.json";
      path = "${config.home.homeDirectory}/.ssh/id_ed25519_github";
      mode = "0600";
    };
    secrets."ssh/id_ed25519_gitea" = {
      format = "binary";
      sopsFile = self + "/files/ssh/private/id_ed25519_gitea.sops.json";
      path = "${config.home.homeDirectory}/.ssh/id_ed25519_gitea";
      mode = "0600";
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
    flavor = "macchiato";
    zsh-syntax-highlighting.enable = true;

    micro = {
      enable = true;
      flavor = "macchiato";
    };
  };

  home.packages = with pkgs; [
  	wget
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
    python313
    docker
    delta
    shfmt
    coreutils
  ];

  home.sessionVariables.MICRO_TRUECOLOR = "1";

  programs.micro = {
    enable = true;
  };

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
        catppuccin = {
          enable = true;
          flavor = "macchiato";
        };
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
        proxyCommand = "${pkgs.netcat-openbsd}/bin/nc -x 127.0.0.1:10801 -X connect %h %p";
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
