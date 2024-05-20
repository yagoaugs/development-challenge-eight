#!/bin/bash

sudo apt update
sudo apt upgrade -y

# Install Packages
sudo apt install certbot -y

# Add Docker's official GPG key:
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y
sudo usermod -aG docker ubuntu
newgrp docker

# AWS CLI v2
sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip
sudo apt remove unzip -y

sudo hostnamectl set-hostname api-prod


# Activating SWAP
# Step 1: Check if swap is already active
if [[ $(sudo swapon --show) ]]; then
    echo "Swap is already active."
else
    # Step 2: Create a swap file with desired size
    sudo fallocate -l 2G /swapfile

    # Step 3: Set permissions
    sudo chmod 600 /swapfile

    # Step 4: Make the swap file usable
    sudo mkswap /swapfile

    # Step 5: Enable swap
    sudo swapon /swapfile

    # Step 6: Check if swap is enabled
    sudo swapon -s

    # Step 7: Add swapfile to /etc/fstab
    echo '/swapfile   none    swap    sw    0   0' | sudo tee -a /etc/fstab > /dev/null

    echo "Swap setup complete."
fi

# Install Zabbix Agent v2
sudo wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu22.04_all.deb
sudo dpkg -i zabbix-release_6.4-1+ubuntu22.04_all.deb
sudo apt update

sudo apt install zabbix-agent2 zabbix-agent2-plugin-* -y
sudo sed -i 's/Server=127.0.0.1/Server=fakedns.yagoaugusto.com' /etc/zabbix/zabbix_agent2.conf
sudo systemctl restart zabbix-agent2
sudo systemctl enable zabbix-agent2