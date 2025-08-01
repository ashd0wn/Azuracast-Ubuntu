#!/usr/bin/env bash
set -euo pipefail

UBUNTU_CODENAME=$(lsb_release -cs)  # noble
MARIADB_VERSION=11.8

echo "Installation de MariaDB $MARIADB_VERSION sur Ubuntu $UBUNTU_CODENAME"

# prérequis
sudo apt update
sudo apt install -y apt-transport-https curl ca-certificates gnupg

# Ajouter la clé de signature
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://mariadb.org/mariadb_release_signing_key.pgp \
  | gpg --dearmor | sudo tee /etc/apt/keyrings/mariadb-keyring.pgp > /dev/null

# Ajouter le dépôt officiel
echo "deb [signed-by=/etc/apt/keyrings/mariadb-keyring.pgp] https://deb.mariadb.org/$MARIADB_VERSION/ubuntu $UBUNTU_CODENAME main" \
  | sudo tee /etc/apt/sources.list.d/mariadb.list >/dev/null

sudo apt update

# Installation des paquets MariaDB
sudo apt install -y mariadb-server mariadb-client

# Activer et démarrer MariaDB
sudo systemctl enable mariadb
sudo systemctl start mariadb
sudo systemctl status mariadb --no-pager

# Sécurisation initiale
echo "Sécurisation initiale avec mysql_secure_installation"
sudo mysql_secure_installation <<EOF

Y
secure_root_password_here
Y
Y
Y
Y
EOF

echo "MariaDB $MARIADB_VERSION installée et sécurisée."
