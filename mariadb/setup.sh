#!/usr/bin/env bash

##############################################################################
# setup_mariadb_for_ubuntu_2404_native
##############################################################################

# Ce script installe MariaDB en utilisant les dépôts officiels d'Ubuntu 24.04 (Noble Numbat).
# Cela permet de résoudre les problèmes de dépendance avec Perl.

# Installer les dépendances nécessaires.
# La commande 'apt_get_with_lock' a été remplacée par 'sudo apt-get' car elle n'est pas une commande standard.
sudo apt-get update -y
sudo apt-get install -y wget software-properties-common

# --- Installation de MariaDB depuis le dépôt officiel d'Ubuntu ---

# Les dépôts officiels d'Ubuntu 24.04 contiennent MariaDB 10.11.
# Cette version est entièrement compatible avec les autres paquets du système.
echo "Installation de MariaDB 10.11 depuis les dépôts officiels d'Ubuntu 24.04..."
sudo apt-get install -y mariadb-server mariadb-client

# --- Fin de l'installation de MariaDB ---

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
