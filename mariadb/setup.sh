#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

# Variables AzuraCast à adapter selon votre environnement
set_azuracast_database="azuracast"
set_azuracast_username="azuracast"
set_azuracast_password="azuracast_password"

UBUNTU_CODENAME=$(lsb_release -cs)  # noble
MARIADB_VERSION=11.8

echo "→ Installation de MariaDB ${MARIADB_VERSION} sur Ubuntu ${UBUNTU_CODENAME}"

# Pré-requis
sudo apt update
sudo apt install -y apt-transport-https curl ca-certificates gnupg lsb-release software-properties-common

# Ajout de la clé GPG officielle
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://mariadb.org/mariadb_release_signing_key.pgp \
  | gpg --dearmor | sudo tee /etc/apt/keyrings/mariadb-keyring.pgp > /dev/null

# Ajout du dépôt officiel MariaDB
echo "deb [signed-by=/etc/apt/keyrings/mariadb-keyring.pgp] https://downloads.mariadb.com/MariaDB/mariadb-${MARIADB_VERSION}/repo/ubuntu ${UBUNTU_CODENAME} main" \
  | sudo tee /etc/apt/sources.list.d/mariadb.list > /dev/null

# Mise à jour et installation
sudo apt update
sudo apt install -y mariadb-server mariadb-client

# Démarrer et activer le service
sudo systemctl enable --now mariadb

# Création base de données AzuraCast
echo "→ Création de la base de données AzuraCast et de l'utilisateur"

mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS \`${set_azuracast_database}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER IF NOT EXISTS '${set_azuracast_username}'@'localhost' IDENTIFIED BY '${set_azuracast_password}';
GRANT ALL PRIVILEGES ON \`${set_azuracast_database}\`.* TO '${set_azuracast_username}'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "✅ Base de données '${set_azuracast_database}' et utilisateur '${set_azuracast_username}' configurés."
