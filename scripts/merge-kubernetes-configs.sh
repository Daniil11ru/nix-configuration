set -eu

base_config="$HOME/.kube/config"
provider_config="$1"
kubectl_bin="$2"

if [ -f "$provider_config" ]; then
  if [ -f "$base_config" ]; then
    KUBECONFIG="$base_config:$provider_config" \
      "$kubectl_bin" config view --flatten > "$base_config.tmp"
    mv "$base_config.tmp" "$base_config"
  else
    cp "$provider_config" "$base_config"
  fi
  chmod 600 "$base_config"
fi
