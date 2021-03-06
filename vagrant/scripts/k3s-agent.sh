#!/bin/bash

function log_info {
  echo -e "\e[90m[INFO]  $1\e[0m"
}

SERVER_IP=$1
K3S_TOKEN=$(cat /vagrant_data/k3s/server/node-token)
FLAGS="--flannel-iface enp0s8"

log_info "Installing k3s agent"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="$FLAGS" K3S_URL="https://$SERVER_IP:6443" K3S_TOKEN="$K3S_TOKEN" K3S_NODE_NAME="$(hostname)" sh -
