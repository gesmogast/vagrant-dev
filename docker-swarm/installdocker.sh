#!/bin/bash
# Docker installation

# Install prerequisites
apt-get update && apt-get install -y --no-install-recommends \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual curl
# Fetch docker repo gpg key
curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -
# Add docker repository key
apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D
# Add docker repository
add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"
# Install docker
apt-get update && apt-get -y install docker-engine

