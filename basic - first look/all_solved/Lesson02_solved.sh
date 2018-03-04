#!/usr/bin/env bash   
#title           : Lesson02_solved
#description     : Presented solution of the task from the bash lesson.
#author		     : Piotr "TheRealMamuth" Kośka
#date            : 24.02.2018
#version         : v1.0   
#usage		     :
#notes           :
#bash_version    : 4.4.12(1)-release
#editor          : visual studio code
#==============================================================================

# Zmienne
# Variables
currentDate=$(date +"%F") # Data Date
currentTime=$(date +"%T") # Czas Time

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

#	Zwykły update i upgrade
#	Regular update and upgrade
function update_pack()
{
    sudo apt-get update && sudo apt-get upgrade -y |& tee -a log$currentDate.log
}

function main()
{
	# [PL] Instalowanie aktualizacji
	# [ENG] Installing the update
	update_pack

	# [PL] Instalacja usług
	# [ENG] Installation of services
	check_install apache2 php7.0 libapache2-mod-php7.0 mysql-server php7.0-mysql phpmyadmin proftpd openssl
}

# Begin

# [PL]Wywołanie funkcji main.
# [ENG] Calling the main function.
main

# End.