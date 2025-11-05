{
  description = "Shell for Caplag";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs = { self, nixpkgs }:
  let
    system = builtins.currentSystem;
    pkgs = import nixpkgs { inherit system; };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [ 
        go
        kubectl
        kubernetes-helm
        fluxcd
        terraform
      ];
    };
  };
}
