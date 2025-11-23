{ config, lib, pkgs, pkgsUnstable, self, ... }:

let
  cfg = config.my.kubernetes;

  providerKubeconfigPath =
    "${config.home.homeDirectory}/.kube/kubeconfig.timeweb.yaml";

  mergeKubeconfigScript = pkgs.writeShellScript "merge-kubernetes-configs" (
    builtins.readFile (self + "/scripts/merge-kubernetes-configs.sh")
in {
  options.my.kubernetes.enable =
    lib.mkEnableOption "Инструменты и файлы конфигурации для Kubernetes";

    sops.secrets."kubeconfig/timeweb" = {
      sopsFile = self + "/files/kubernetes/configs/timeweb.sops.yaml";
      path = providerKubeconfigPath;
      mode = "0600";
    };

    home.activation.mergeKubeconfig =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p "$HOME/.kube"
        chmod 700 "$HOME/.kube"

        ${mergeKubeconfigScript} \
          "${providerKubeconfigPath}" \
          "${pkgs.kubectl}/bin/kubectl"
      '';

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
