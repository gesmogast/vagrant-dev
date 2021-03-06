#!/bin/bash
# Docker installation

# Install prerequisites
apt-get install -y --no-install-recommends \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual curl
curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -
# Add docker repository key
apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D
# Add docker repository
add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"
# Install docker
apt-get update && apt-get -y install docker-engine glusterfs-server
# Install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.11.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# Allow execution to docker-compose
chmod +x /usr/local/bin/docker-compose
# Start glusterfs server
service glusterfs-server start
# Create directories to store data
mkdir -p /gluster/data /swarm/volumes

