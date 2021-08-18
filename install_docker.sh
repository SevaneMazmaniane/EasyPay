#!/bin/sh

set -o errexit
set -o nounset

IFS=$(printf '\n\t')

##########
# Docker #
##########

sudo apt remove --yes docker docker.io containerd runc
sudo apt update
sudo apt --yes --no-install-recommends install apt-transport-https ca-certificates
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release --codename --short) stable"
sudo apt update
sudo apt --yes --no-install-recommends install docker-ce docker-ce-cli containerd.io
sudo usermod --append --groups docker "$USER"
sudo systemctl enable docker
printf '\nDocker installed successfully\n\n'

##################
# Docker Compose #
##################

sudo apt-get install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker container run hello-world
printf '\nDocker Compose installed successfully\n\n'

###################################
# Run Docker command without Sudo #
###################################

echo "///////////////////////////////////////////"
docker --version
docker-compose --version
echo "///////////////////////////////////////////"

sudo usermod -aG docker $(whoami)
newgrp docker
