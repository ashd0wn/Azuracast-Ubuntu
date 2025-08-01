#!/usr/bin/env bash

#!/bin/bash

# Fonction pour attendre la libération des verrous APT
wait_for_apt_lock() {
    echo "Waiting for APT lock to be released..."
    while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 || fuser /var/lib/apt/lists/lock >/dev/null 2>&1 || fuser /var/cache/apt/archives/lock >/dev/null 2>&1; do
        sleep 5
    done
    echo "APT lock released."
}

# ... (le reste de votre script commence ici) ...
# Exit if the installer has already been run
#if [ -e "$installerHome/azuracast_installer_runned" ]; then
#  echo "Installer has already been run. Exiting..."
#  exit 1
#fi

# Stop unattended-upgrades (suppress any errors)
systemctl stop unattended-upgrades || true

# Update and upgrade packages
wait_for_apt_lock
apt update
wait_for_apt_lock
apt upgrade -y

# Add multiverse, universe, and restricted repositories
add-apt-repository -y multiverse universe restricted

# Update package lists again
wait_for_apt_lock
apt update

# Mark installer as run
touch $installerHome/azuracast_installer_runned

# Issue: https://github.com/ashd0wn/AzuraCast-Ubuntu/issues/1#issuecomment-1440983104
# Check for the existence of the adm group and create if it doesn't exist
if ! grep -q "^adm:" /etc/group; then
  echo "adm group not found. Adding adm group with members syslog and ubuntu."
  echo "adm:x:4:syslog,ubuntu" >>/etc/group
else
  echo "adm group already exists, nothing to do."
fi

# Install system packages and dependencies
wait_for_apt_lock
apt install -y build-essential pwgen whois zstd software-properties-common \
  apt-transport-https ca-certificates language-pack-en tini gosu curl wget \
  tar zip unzip git rsync tzdata gpg-agent openssh-client openssl

# Set the system locale to en_US.UTF-8
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8
