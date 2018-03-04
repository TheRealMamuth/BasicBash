#!/bin/bash -       
#title           : Lesson03_solved
#description     : Presented solution of the task from the bash lesson.
#author		     : Piotr "TheRealMamuth" Kośka
#date            : 24.02.2018
#version         : v1.0   
#usage		     :
#notes           :
#bash_version    : 4.4.12(1)-release
#editor          : visual studio code
#==============================================================================

# Variables / Zmienne
RED="\e[0;31m" # red
GREEN="\e[0;32m" # green
NC="\e[0m" # return to normal color
BLUE="\e[0;34m" # blue

currentDate=$(date +"%F") # Date
currentTime=$(date +"%T") # Time

function mysystem_info()
{
    # Jako ciekawostka możesz zobczyć takie polecia oczywiście bez #
        # cat /etc/issue.net
        # cat /etc/lsb-lsb_release
        # cat /proc/sys/kernel/{ostype,osrelease,version}
        # uname -a | egrep -Eo '#.{1,100}'
        # uname -mrs
    # i kilka innych mozliwości.

    # As a curiosity, you can command such a course without #
         # cat /etc/issue.net
         # cat / etc / lsb-lsb_release
         # cat / proc / sys / kernel / {ostype, osrelease, version}
         # uname -a | egrep -Eo '#. {1,100}'
         # uname -mrs
     # and several other possibilities.

    if [ $# -eq 0 ]; then
        echo -e "${BLUE}WARNING - Nie podałeś żadnych argumentów dla funkcji.$NC"
        exit 1
    fi

    for myargs in "$@"
    do
        # Kernel version
        if [ $myargs = 'kernel' ]; then
            echo -e "${GREEN}Twoja wersja karnela to: "$(uname -r)"$NC"
        fi

        # OS type
        if [ $myargs = 'ostype' ]; then
            echo -e "${GREEN}Twój system jest z rodziny: "$(uname -s)"$NC"
        fi

        # Distro version
        if [ $myargs = 'distro' ]; then
            echo -e "${GREEN}Uzywasz dystrybucji: "$(cat /proc/sys/kernel/version)"$NC"
        fi

        # Platform
        if [ $myargs = 'platform' ]; then
            echo -e "${GREEN} Platforma: "$(uname -m)"$NC"
        fi

    done
}

function user_list()
{
#   komunikat gdy podamy za mało parametrów do funkcji - komunikat z kolorami.
#   message when we give too few parameters to the function - message with colors.
    if [ $# -lt 1 ]; then
        echo -e "${BLUE}WARNING: Użyj - ${GREEN}$0 ${RED}parametr$NC"
        echo -e "${BLUE}Dostepne parametry to:$NC"
        echo -e "${GREEN}home - ${NC}Zwraca użytkowników z ścieżką /home"
        echo -e "${GREEN}uid - ${NC}Zwraca użytkowników z ścieżką /home"
        echo -e "${GREEN}homeuid - ${NC}Zwraca użytkowników z ścieżką /home"
        echo -e "${GREEN}bash - ${NC}Zwraca użytkowników z ścieżką /home"
    fi


    case "$1" in 
        home)
#           Opcja gdy parametr home.
#           Option when the home parameter.
            echo -e "${GREEN}Lista użytkowników: $NC"
            awk -F: '/\/home/ {printf "%s:%s\n",$1,$3}' /etc/passwd
            ;;
        uid)
#           Opcja gdy parametr uid.
#           Option when the uid parameter.
            echo -e "${GREEN}Lista użytkowników: $NC"
            awk -F: '($3 >= 1000) {printf "%s:%s\n",$1,$3}' /etc/passwd
            ;;
        homeuid)
#           Opcja gdy parametr homeuid.
#           Option when the homeuid parameter.
            echo -e "${GREEN}Lista użytkowników: $NC"
            awk -F: '/\/home/ && ($3 >= 1000) {printf "%s:%s\n",$1,$3}' /etc/passwd
            ;;
        bash)
#           Opcja gdy parametr bash.
#           Option when the bash parameter.
            echo -e "${GREEN}Lista użytkowników: $NC"
            cat /etc/passwd | grep "/bin/bash" | cut -d: -f1
            ;;
        *) 
#          Opcja gdy parametr inny niz powyższe.
#          Option when parameter other than the above.        
           echo -n "Chcesz wyświetlic listę Użytkoników? [tak czy nie]: "
           read tnie
           case $tnie in
                [tT] | [tT][aA][kK] )
                    echo -e "${GREEN}Lista użytkowników: $NC"
                    cut -d: -f1 /etc/passwd
                    ;;
                nN | [n|N][i|I][e|E] )
                    echo -e "${BLUE}Pa Pa Pa$NC"
                    ;;
           esac
           ;;
    esac
}

# Funkcja wyswietla grupy dostepne w systemie
# The function displays groups available in the system
function group_list()
{
    case "$1" in
        cut)
            echo -e "${GREEN}Lista grup:$NC"
            cut -d : -f 1 /etc/group
            ;;
        awk)
            echo -e "${GRENN}Lista grup:$NC"
            awk -F ':' '{print $1}' /etc/group
            ;;
        *)
            echo -e "${RED}Nie wyświetle listy grup.$NC"
            ;;
    esac
}

# Funkcja wyswietla interfejsy sieciowe
# Function display network interfaces
function net_interfaces()
{
    case "$1" in
        inet)
            echo "Wykaz wszystkich interfejsów sieciowych:"
            ip link show
            ;;
        stat)
            echo "Wykaz interfejsów sieciowych (nazwy) oraz czy jest UP / DOWN:"
            ip -o link show | awk '{print $2,$9}'
            ;;
        iname)
            echo "Wykaz interfejsów sieciowych - same nazwy:"
            ip -o link show | awk -F': ' '{print $2}'
            ;;
        kerneli)
            echo "Lista interfejsów sieciowych widzianych przez Kernel:"
            netstat -i
            ;;
        iaddress)
            echo "Tu wykorzytsanie petli for i nazwa interfejsów z adresami IPv4 i IPv6:" | tee -a Zadanie.txt
            for i in $(ip ntable | grep dev | sort -u | awk '{print $2}'); do echo "Interfejs sieciowy: "$i; ifconfig $i | grep inet | sed -e 's/\<inet\>/IPv4:/g' | sed -e 's/\<inet6\>/IPv6:/g' | awk 'BEGIN{OFS="\t"}{print $1, $2}'; done
            ;;
        ifls)
            echo "Lista podłaczonych urządzeń:"
            ls /sys/class/net
    esac
        
}

# Funkcja wysietla informacje o dysku
# The function displays disk information
function volume_info()
{
    if [ $# -eq 0 ]; then
        df -h
        exit 0
    fi

    if [ $1 = 'total' ]; then
        df -h --total
    fi
}

function main()
{
    #mysystem_info $1
    #user_list $1
    #group_list $1
    #net_interfaces $1
    volume_info $1
}

main $1