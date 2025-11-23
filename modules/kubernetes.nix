{ config, lib, pkgs, pkgsUnstable, ... }:

let
  cfg = config.my.kubernetes;
in {
  options.my.kubernetes.enable =
    lib.mkEnableOption "Инструменты для Kubernetes";

  config = lib.mkIf cfg.enable {
    home.packages =
      (with pkgs; [
        kubectl
        kubernetes-helm
        terraform
      ])
      ++ (with pkgsUnstable; [
        fluxcd
      ]);
  };
}
