# Set up a sandbox K3s cluster using Vagrant

## Pre-requisite

- Install VirtualBox
- Install Vagrant

## Guide

1. Create a folder for kubeconfig and node token (used for registering agent nodes to cluster) to be written to.

```bash
cd vagrant
mkdir -p .vagrant/k3s
```

2. Create the VMs

```bash
vagrant up
```

## Troubleshooting

### DNS issues

K3s uses [Flannel](https://github.com/flannel-io/flannel) as the CNI. Flannel selects the first network interface on the VMs spun up by Vagrant by default, which is not the external bridge interface that you configured.

Wrong network interface used:

```bash
$ kubectl get nodes k3s-server -o yaml
apiVersion: v1
kind: Node
metadata:
  annotations:
    # removed for brevity
    k3s.io/external-ip: 192.168.56.4
    k3s.io/hostname: k3s-server
    k3s.io/internal-ip: 10.0.2.15 # by default Flannel uses enp0s3 (10.0.2.15) instead of enp0s8 (192.168.56.4)
```

```bash
vagrant@k3s-server:~$ ip a s | grep -i "UP\|inet"
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host 
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
    inet6 fe80::e0:b1ff:fe59:f49d/64 scope link 
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    inet 192.168.56.4/24 brd 192.168.56.255 scope global enp0s8
    inet6 fe80::a00:27ff:fec9:c597/64 scope link
```

The fix is to pass in `--flannel-iface enp0s8` when installing K3s server and agents, which tells Flannel to select the second interface instead.

References:
- https://github.com/flannel-io/flannel/blob/master/Documentation/troubleshooting.md#vagrant
- https://www.jeffgeerling.com/blog/2019/debugging-networking-issues-multi-node-kubernetes-on-virtualbox
- https://stackoverflow.com/questions/66449289/is-there-any-way-to-bind-k3s-flannel-to-another-interface

### K3s agents not joining cluster

When installing K3s agents, the agents do not join the cluster automatically as expected.

The fix is to pass in `--tls-san $SERVER_IP` when installing K3s server, so that the IP is added as a Subject Alternative Name in the TLS certificate.

References:
- https://superuser.com/questions/1670418/k3s-slave-agents-dont-join-kubernetes-cluster-in-vagrantbox-setup
- https://gitlab.com/sommerfeld.sebastian/v-kube-cluster/-/tree/feat/k3s/src/main/k3s
