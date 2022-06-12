# Set up a sandbox K3s cluster using Vagrant

## Pre-requisite

- Install VirtualBox
- Install Vagrant

## Guide

1. Create a folder for kubeconfig and node token to be written to.

```bash
cd vagrant
mkdir -p .vagrant/k3s
```

2. Create the VMs

```bash
vagrant up
```
