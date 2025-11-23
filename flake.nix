{
  description = "NixOS (WSL), Home Manager and projects";

  inputs = {
    catppuccin.url  = "github:catppuccin/nix?ref=release-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, catppuccin, nixos-wsl, sops-nix, ... }:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    pkgsUnstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.wsl = lib.nixosSystem {
      system = system;
      specialArgs = { inherit system self pkgsUnstable; };

      modules = [
        nixos-wsl.nixosModules.wsl

        ./hosts/wsl.nix

        { nixpkgs.config.allowUnfree = true; }

        home-manager.nixosModules.home-manager
        {
          home-manager.backupFileExtension = "hm-backup";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.sharedModules = [
            sops-nix.homeManagerModules.sops
          ];

          home-manager.extraSpecialArgs = { inherit catppuccin self pkgsUnstable; };

          home-manager.users.nixos = import ./users/nixos.nix;
        }
      ];
    };
  };
}
