{ config, lib, pkgs, ... }:

let
  python = pkgs.python313;
in {
  options.my.python.packages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [ ];
    description = "Список Python-пакетов для общего окружения";
  };

  config = {
    home.packages = [
      (python.withPackages (ps: config.my.python.packages))
    ];
  };
}
