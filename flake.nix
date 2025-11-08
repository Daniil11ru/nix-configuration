{
  description = "NixOS (WSL), Home Manager and projects";

  inputs = {
    catppuccin.url  = "github:catppuccin/nix?ref=release-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, nixos-wsl, ... }:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
  in {
    nixosConfigurations.wsl = lib.nixosSystem {
      inherit system;

      modules = [
        nixos-wsl.nixosModules.wsl

        ./hosts/wsl.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.backupFileExtension = "hm-backup";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = { inherit catppuccin; };

          home-manager.users.nixos = import ./home/nixos.nix;
        }
      ];
    };
  };
}
