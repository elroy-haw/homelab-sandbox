#!/bin/bash

function log_info {
  echo -e "\e[90m[INFO]  $1\e[0m"
}

SERVER_IP=$1
KUBECONFIG_SRC=/etc/rancher/k3s/k3s.yaml
KUBECONFIG_DST=/vagrant_data/k3s/k3s.yaml
K3S_TOKEN_SRC=/var/lib/rancher/k3s/server/node-token
K3S_TOKEN_DST=/vagrant_data/k3s/server/node-token
FLAGS="--tls-san $SERVER_IP --flannel-iface enp0s8 --disable traefik --disable servicelb"

log_info "Installing k3s server"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="$FLAGS" K3S_NODE_NAME="$(hostname)" K3S_KUBECONFIG_MODE="644" sh -

log_info "Writing kubeconfig to $KUBECONFIG_DST"
cp $KUBECONFIG_SRC $KUBECONFIG_DST

log_info "Writing k3s token to $K3S_TOKEN_DST"
cp $K3S_TOKEN_SRC $K3S_TOKEN_DST
