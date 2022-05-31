#!/bin/bash
set -e

# install docker
if [ ! -x "$(command -v docker)" ]; then
    echo 'installing docker..'
    sudo apt update
    sudo apt-get install -y ca-certificates curl software-properties-common apt-transport-https gnupg lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    sudo groupadd docker
    sudo usermod -aG docker $USER
fi

# install docker-compose
if [ ! -e /usr/local/bin/docker-compose ]; then
    echo 'installing docker-compose..'
    sudo curl -L https://github.com/docker/compose/releases/download/v2.1.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# create backup directories
mkdir -p data/certbot/conf
mkdir -p data/certbot/www
mkdir -p data/ghost/content

# initialize letsencrypt
./init_letsencrypt.sh

docker-compose up
