#!/bin/sh

set -o errexit
set -o nounset

IFS=$(printf '\n\t')

###############################
# AWS CLI v2 Installer script #
###############################
sudo apt update
sudo apt install unzip
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
aws --version
printf '\nAWS CLI v2 installed successfully\n\n'

############################################
# Ansible and AWS Python libraries via pip #
############################################
sudo apt update -y
sudo apt install python3-pip -y
python3 -m pip install --upgrade pip
python3 -m pip install ansible boto boto3 --user

##########
# Docker #
##########

sudo apt remove --yes docker docker.io containerd runc
sudo apt update -y
sudo apt --yes --no-install-recommends install apt-transport-https ca-certificates
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release --codename --short) stable"
sudo apt update -y
sudo apt --yes --no-install-recommends install docker-ce docker-ce-cli containerd.io
sudo usermod --append --groups docker "$USER"
sudo systemctl enable docker
printf '\nDocker installed successfully\n\n'

##################
# Docker Compose #
##################

sudo apt-get install docker-compose -y
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
