#!/usr/bin/env bash

##############################################################################
# setup_mariadb_for_ubuntu_2404
##############################################################################

# Ce script est optimisé pour Ubuntu 24.04 (Noble Numbat) et MariaDB 11.8.

# Installer les dépendances nécessaires pour ajouter un dépôt externe.
# La commande 'apt_get_with_lock' a été remplacée par 'sudo apt-get' car elle n'est pas une commande standard.
sudo apt-get install -y wget software-properties-common dirmngr ca-certificates apt-transport-https

# --- Configuration du dépôt MariaDB pour Ubuntu 24.04 ---

# Utiliser le script officiel de configuration de dépôt MariaDB.
# J'ai ajouté les paramètres --os-type="ubuntu" et --os-version="noble" pour corriger l'erreur de "os-type or os-version".
curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | sudo bash -s -- --mariadb-server-version="mariadb-11.8" --os-type="ubuntu" --os-version="noble"

# Mettre à jour la liste des paquets après l'ajout du nouveau dépôt.
sudo apt-get update -y

# --- Fin de la configuration du dépôt ---

# Installer le serveur et le client MariaDB.
sudo apt-get install -y mariadb-server mariadb-client

# Créer la base de données AzuraCast avec les variables fournies.
# Utilisation de utf8mb4 pour une compatibilité complète avec les caractères spéciaux.
/usr/bin/mariadb -e "create database $set_azuracast_database character set utf8mb4 collate utf8mb4_bin;"
/usr/bin/mariadb -e "create user \`$set_azuracast_username\`@localhost identified by '$set_azuracast_password';"
/usr/bin/mariadb -e "grant all privileges on $set_azuracast_database.* to \`$set_azuracast_username\`@localhost;"

# Le script original note que la sécurisation de l'installation sera effectuée plus tard.
echo "La sécurisation de l'installation de MariaDB sera gérée par une autre étape."

# Désactiver et arrêter le service MariaDB pour permettre à Supervisor de le gérer.
systemctl disable mariadb
systemctl stop mariadb
