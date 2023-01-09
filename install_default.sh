#!/usr/bin/env bash

##############################################################################
# Azuracast Installer / Default, Latest Stable
##############################################################################

cat <<EOF
***************************************************************************
                        Azuracast $set_azuracast_version Installation
***************************************************************************

For more verbose logs, open up a second terminal and use the following command:

tail -f $installerHome/azuracast_installer.log
EOF

echo -en "
***************************************************************************
Please be aware. Do not interrupt the install process.
Sit back, relax and hit nothing on your keyboard!

Depending on your System, installation will take around 25 minutes or more.

Also remember. If only one process failed, reinstall your system with Ubuntu 22.04 and try again!
This installer may not support any of your preinstalled third party software.
***************************************************************************

"

# User should read above. So lets wait.
sleep 6

# ask_for_settings
source misc/ask_for_settings.sh

# prepare_system
echo -en "\n- 1/10 prepare_system\n"
source misc/prepare_system.sh &>>"${LOG_FILE}"

# setup_azuracast_user
echo -en "\n- 2/10 setup_azuracast_user\n"
source azuracast/user.sh &>>"${LOG_FILE}"

# setup_mariadb
echo -en "\n- 3/10 setup_mariadb\n"
source mariadb/setup.sh &>>"${LOG_FILE}"

# setup_stations
echo -en "\n- 4/10 setup_stations\n"
source stations/setup.sh &>>"${LOG_FILE}"

# setup_web
echo -en "\n- 5/10 setup_web\n"
source web/setup.sh &>>"${LOG_FILE}"

# setup_sftpgo
echo -en "\n- 6/10 setup_sftpgo\n"
source sftpgo/setup.sh &>>"${LOG_FILE}"

# setup_azuracast_install
echo -en "\n- 7/10 setup_azuracast_install\n"
source azuracast/install.sh &>>"${LOG_FILE}"

# Just check permissions again
echo -en "\n- 8/10 Set Azuracast Permissions\n"
chown -R azuracast.azuracast /var/azuracast &>>"${LOG_FILE}"

# setup_supervisor
echo -en "\n- 9/10 setup_supervisor\n"
source supervisor/setup.sh &>>"${LOG_FILE}"

# Update and Upgrade System again
echo -en "\n- 10/10 Set Azuracast Permissions\n"
source misc/finalize.sh &>>"${LOG_FILE}"

echo -en "
***************************************************************************
Whup! Whup! Azuracast Installation is complete.
  - The server will be accessible at at http://$user_hostname

  - MySQL "root" User: root
  - MySQL "root" Password: $mysql_root_pass

  - MySQL "Azuracast" DB Name: $set_azuracast_database
  - MySQL "Azuracast" DB User: $set_azuracast_username
  - MySQL "Azuracast" DB Password: $set_azuracast_password

Please do not disturb the Azuracast Team with errors in this Installer.
The Developers only support the Docker variant!

If needed, you will find a log of your installations process here: $installerHome/azuracast_installer.log
Your credentials where also saved to: $installerHome/azuracast_details.txt
You should delete the Install folder now: $installerHome

Because of Updates, some service restarts and maybe also Kernel ones. I prefer to reboot now.
***************************************************************************\n
" | tee $installerHome/azuracast_details.txt
