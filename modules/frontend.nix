{ config, lib, pkgs, pkgsUnstable, self, ... }:

let
  cfg = config.my.frontend;
in {
  options.my.frontend.enable =
    lib.mkEnableOption "Frontend";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.bun
    ];

    my.python.packages = with pkgs.python313Packages; [
      fastapi
      pydantic
      uvicorn
    ];
  };
}
