{ config, lib, pkgs, pkgsUnstable, self, ... }:

let
  cfg = config.my.kubernetes;

  providerKubeconfigPath =
    "${config.home.homeDirectory}/.kube/kubeconfig.timeweb.yaml";

  mergeKubeconfigScript = pkgs.writeShellScript "merge-kubernetes-configs" (
    builtins.readFile (self + "/scripts/merge-kubernetes-configs.sh")
  );
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

    sops.secrets."docker/config" = {
      sopsFile = self + "/files/docker/config.json";

      format = "binary";
      key = "";

      path = "${config.home.homeDirectory}/.docker/config.json";
      mode = "0600";
    };

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
