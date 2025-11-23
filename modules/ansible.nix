{ config, lib, pkgs, pkgsUnstable, self, ... }:

let
  cfg = config.my.ansible;
in {
  options.my.ansible.enable =
    lib.mkEnableOption "Ansible";

  config = lib.mkIf cfg.enable {
    home.packages =
      (with pkgs; [
        cowsay
      ])
      ++ (with pkgsUnstable; [
        ansible
        ansible-lint
      ]);
  };
}
