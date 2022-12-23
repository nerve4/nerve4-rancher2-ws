#!/bin/bash
# -------------------------------------------------------
# rke2 - (Master) Node Installation
# License: MIT
# Maintainer: nerve4
# -------------------------------------------------------

# Swap Off
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Helm Install on Debian based distributions
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt update
sudo apt install helm

# kubectl install on Debian based distributions
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubectl

# Run the installer
curl -sfL https://get.rke2.io | sh -

# Enable the rke2-server service
systemctl enable rke2-server.service

# Start the service
systemctl start rke2-server.service
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml PATH=$PATH:/var/lib/rancher/rke2/bin

# Run "node check" amd get the cluster token
clear
echo "rke2 - (Master) Node Installation has been completed"
echo "====================================================="
kubectl get no
echo "====================================================="
echo "Node token is: "
cat /var/lib/rancher/rke2/server/node-token

exit 127