#!/bin/bash
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl start docker
systemctl status docker
systemctl enable docker
usermod  -aG docker ec2-user #then logout and login the server
echo "Logout and Login again"