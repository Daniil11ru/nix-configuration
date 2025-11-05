{
  description = "NixOS (WSL), Home Manager and projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };

  outputs = { self, nixpkgs, home-manager, nixos-wsl, ... }:
  let
    system = builtins.currentSystem;
    lib = nixpkgs.lib;
  in {
    nixosConfigurations.wsl = lib.nixosSystem {
      inherit system;

      modules = [
        nixos-wsl.nixosModules.wsl

        ./hosts/wsl.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.nixos = import ./home/nixos.nix;
        }
      ];
    };
  };
}
