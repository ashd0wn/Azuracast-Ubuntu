#!/usr/bin/env bash

##############################################################################
# setup_mariadb_for_ubuntu_2404
##############################################################################

# Ce script est optimisé pour Ubuntu 24.04 (Noble Numbat) et MariaDB 11.8.

# Installer les dépendances nécessaires pour ajouter un dépôt externe.
apt_get_with_lock install -y wget software-properties-common dirmngr ca-certificates apt-transport-https

# Ajouter le dépôt MariaDB 11.8.
# La version "noble" d'Ubuntu 24.04 est ciblée.
apt_get_with_lock install software-properties-common gnupg2 -y
apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
add-apt-repository -y 'deb [arch=amd64] http://mariadb.mirror.globo.tech/repo/11.8/ubuntu noble main'
apt_get_with_lock update -y

# Installer le serveur et le client MariaDB.
apt_get_with_lock install -y mariadb-server mariadb-client

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
