#!/bin/bash
# -------------------------------------------------------
# rke2 - (Master) Node Installation
# License: MIT
# Maintainer: nerve4
# -------------------------------------------------------

# Swap Off
swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
mount -a

# Helm Install on CentOS7 based distributions
sudo yum install -y wget
wget https://get.helm.sh/helm-v3.7.0-linux-amd64.tar.gz -P /tmp/
sudo tar xvzf /tmp/helm-v3.7.0-linux-amd64.tar.gz -C /tmp/
sudo mv /tmp/linux-amd64/helm /usr/local/bin
sudo rm -rf /tmp/helm-v3.7.0-linux-amd64.tar.gz && sudo rm -rf /tmp/linux-amd64

# kubectl install on CentOS7 based distributions
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

sudo yum install -y kubectl

# Run the installer
curl -sfL https://get.rke2.io | sh -

# Enable the rke2-server service
systemctl enable rke2-server.service

# Start the service
systemctl start rke2-server.service

# Setup firewalld
yum install firewalld -y
systemctl start firewalld && systemctl enable firewalld

# For control plane nodes, run the following commands:
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --permanent --add-port=2376/tcp
firewall-cmd --permanent --add-port=2379/tcp
firewall-cmd --permanent --add-port=2380/tcp
firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --permanent --add-port=8472/udp
firewall-cmd --permanent --add-port=9099/tcp
firewall-cmd --permanent --add-port=9345/tcp
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --permanent --add-port=10254/tcp
firewall-cmd --permanent --add-port=30000-32767/tcp
firewall-cmd --permanent --add-port=30000-32767/udp

# Reload the firewalld config
firewall-cmd --reload
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