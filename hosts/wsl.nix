{ config, lib, pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Moscow";

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  programs.nix-ld.enable = true;

  system.stateVersion = "25.05";
}
