{ config, lib, pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Moscow";

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  nixpkgs.overlays = [
    (final: prev: {
      gittype =
        let
          gtPkgs = inputs.gittype.packages.${prev.system};
        in if gtPkgs ? default then gtPkgs.default else gtPkgs.gittype;
    })
  ];

  system.stateVersion = "25.05";
}
