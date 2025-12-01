{ config, lib, pkgs, pkgsUnstable, self, ... }:

let
  cfg = config.my.go;
in {
  options.my.go.enable =
    lib.mkEnableOption "Инструменты для разработки на Go";

  config = lib.mkIf cfg.enable {
    home.packages =
      (with pkgs; [
        go
        gopls
        delve
      ])
  };
}
