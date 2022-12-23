#!/bin/bash
# -------------------------------------------------------
# rke2 - (Worker) Node Installation
# License: MIT
# Maintainer: nerve4
# -------------------------------------------------------

# Variables, DO NO~T FORGET TO FILL IT
SERVER_IP="<YOUR-CONTROLPLANE-IP-ADDRESS"
TOKEN="<YOUR-NODE-TOKEN>"

# Swap Off
swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
mount -a

# Setup firewalld
yum install firewalld -y
systemctl start firewalld && systemctl enable firewalld

# For worker nodes, run the following commands:
firewall-cmd --permanent --add-port=22/tcp
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --permanent --add-port=2376/tcp
firewall-cmd --permanent --add-port=8472/udp
firewall-cmd --permanent --add-port=9099/tcp
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --permanent --add-port=10254/tcp
firewall-cmd --permanent --add-port=30000-32767/tcp
firewall-cmd --permanent --add-port=30000-32767/udp

# Reload the firewalld config
firewall-cmd --reload

# Run the installer
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -

# Enable the rke2-agent service
systemctl enable rke2-agent.service

# Configure the rke2-agent service¶
mkdir -p /etc/rancher/rke2/
echo "server: https://$SERVER_IP:9345" | sudo tee /etc/rancher/rke2/config.yaml
echo "token: $TOKEN" \ >> /etc/rancher/rke2/config.yaml

# Start the service
systemctl start rke2-agent.service

clear
echo "rke2 - (Worker) Node Installation has been completed"
echo "====================================================="

exit 127