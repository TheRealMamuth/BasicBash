#!/usr/bin/env bash

# [PL] Funkcje
# [ENG] Functions

function check_install()
{
	# [PL] Funkcja ta sprawdza czy jest zainstalowany pakiet. W przypadku braku pakiety przystepuje do instalacji.
	# [ENG] This function checks if the package is installed. In the absence of packages, it is included in the installation.
    for install in "$@"
    do
        dpkg -s $install &> /dev/null

	    if [ $? -eq 0 ]; then
    	    echo "The $install package is already installed!" |& tee -a log$currentDate.log
	    else
    	    echo "The $install package is not installed, the installation will take place!" |& tee -a log$currentDate.log
		    sudo apt-get install -y $1 |& tee -a log$currentDate.log
	    fi
    done
}

function update_pack ()
{
    sudo apt-get update && sudo apt-get upgrade -y |& tee -a log$currentDate.log
}

# Zmienne
# Variables
currentDate=$(date +"%F") # Data Date
currentTime=$(date +"%T") # Czas Time

# Begin

#Instalowanie aktualizacji
# Installing the update
update_pack

# Instalacja usług
# Installation of services
check_install apache2 php7.0 libapache2-mod-php7.0 mysql-server php7.0-mysql phpmyadmin proftpd openssl

# End.