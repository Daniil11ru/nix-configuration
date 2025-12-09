{ config, lib, pkgs, pkgsUnstable, self, ... }:

let
  cfg = config.my.kubernetes;

  providerKubeconfigPath =
    "${config.home.homeDirectory}/.kube/kubeconfig.timeweb.yaml";

  mergeKubeconfigScript = pkgs.writeShellScript "merge-kubernetes-configs" (
    builtins.readFile (self + "/scripts/merge-kubernetes-configs.sh")
  );

  kftui = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "kftui";
    version = "0.27.2";

    src =
      let
        tag = "v${version}";
        system = pkgs.stdenv.hostPlatform.system;
      in
        if system == "x86_64-linux" then
          pkgs.fetchurl {
            url = "https://github.com/hcavarsan/kftray/releases/download/${tag}/kftui_linux_amd64";
            sha256 = "sha256-FvFrDE/94qWxq7/18nVlM1vQooedKR+DhS/i+R8GZ+w=";
          }
        else if system == "aarch64-linux" then
          pkgs.fetchurl {
            url = "https://github.com/hcavarsan/kftray/releases/download/${tag}/kftui_linux_arm64";
            sha256 = "sha256-vF/mIzrAmC83RvkM/0zyvaTvy4aBWX+/dOCAaNDvavg=";
          }
        else
          throw "kftui не поддерживает ${system}";

    dontUnpack = true;

    installPhase = ''
      mkdir -p "$out/bin"
      cp "$src" "$out/bin/kftui"
      chmod +x "$out/bin/kftui"
    '';
  };
in {
  options.my.kubernetes.enable =
    lib.mkEnableOption "Инструменты и файлы конфигурации для Kubernetes";

  config = lib.mkIf cfg.enable {
    sops.secrets."kubeconfig/timeweb" = {
      sopsFile = self + "/files/kubernetes/configs/timeweb.sops.yaml";
      format = "yaml";
      # Без этого падает с ошибкой
      key = "";
      path = providerKubeconfigPath;
      mode = "0600";
    };

    home.activation.mergeKubeconfig =
      lib.hm.dag.entryAfter [ "writeBoundary" "sops-nix" ] ''
        mkdir -p "$HOME/.kube"
        chmod 700 "$HOME/.kube"

        ${mergeKubeconfigScript} \
          "${providerKubeconfigPath}" \
          "${pkgs.kubectl}/bin/kubectl"
      '';

    home.activation.fixDockerDir = lib.hm.dag.entryAfter [ "sops-nix" ] ''
      mkdir -p "$HOME/.docker"
      chmod 700 "$HOME/.docker"
    '';

    sops.secrets."docker/config" = {
      sopsFile = self + "/files/docker/config.json";

      format = "json";
      key = "";

      path = "${config.home.homeDirectory}/.docker/config.json";
      mode = "0600";
    };

    home.packages =
      (with pkgs; [
        kubectl
        kubernetes-helm
        terraform
        kubetui
        k9s
        oras
      ])
      ++ (with pkgsUnstable; [
        fluxcd
      ])
      ++ [
        kftui
      ];
  };
}
