#!/usr/bin/env sh

sudo apt update
sudo apt install git curl wget software-properties-common

sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible -y

VER=$(curl -s https://api.github.com/repositories/23267883/releases/latest|grep tag_name | cut -d '"' -f 4|sed 's/v//g')
wget "https://github.com/ansible-semaphore/semaphore/releases/download/v${VER}/semaphore_${VER}_linux_amd64.deb"

sudo apt install ./semaphore_${VER}_linux_amd64.deb

sudo rm ./semaphore_${VER}_linux_amd64.deb
