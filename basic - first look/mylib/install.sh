#!/bin/bash -       
#title           : install.sh
#description     : 
#author		     : Piotr "TheRealMamuth" Kośka
#date            : 24.02.2018
#version         : v1.0   
#usage		     :
#notes           :
#bash_version    : 4.4.12(1)-release
#editor          : visual studio code
#==============================================================================

# Functions

function show_message()
{
    # Varables
    RED="\e[0;31m"
    GREEN="\e[0;32m"
    BLUE="\e[0;34m"
    NC="\e[0m"

    
    currentTime=$(date +"%T") # Time

    # BEGIN

    if [ $# -lt 2 ]; then
        echo -e "${BLUE}WARNING: ${GREEN}$0 ${BLUE}wymagane są argumenty 3:$NC ${RED}typ_błedu$NC, ${RED}wiadomość$NC"
        exit 1
    fi

    case "$1" in
        [eE] | [eE][rR][rR][oO][rR] )
            echo -e "${RED}${1}$NC: $2"
            ;;
        [wW] | [wW][aA][rR][nN][iI][nN][gG] )
            echo -e "${BLUE}${1}$NC: $2"
            ;;
        [oO] | [oO][kK] )
            echo -e "${GREEN}${1}$NC: $2"
            ;;
        [iI] | [iI][nN][fF][oO] )
            echo "INFO: ${2}"
            ;;
        *)
            echo -e "${RED}Zła składnia ${BLUE}$0$NC ${RED}dozwolone tylko ${RED}ERROR${NC}, ${BLUE}WARRNING${NC}, ${GREEN}OK${NC}, INFO"
            ;;
    esac

    # END
}

function log_dir()
{
    if [ -d "./log" ]; then
        echo "Katalog "$(pwd)"/log instnieje. " | tee -a ./log/log_${currentDate}.log &> /dev/null
    else
        echo "Katalog "$(pwd)"/log nie instnieje. " | tee -a ./log/log_${currentDate}.log &> /dev/null
        mkdir ./log/
        echo "Katalog "$(pwd)"/log utworzony " | tee -a ./log/log_${currentDate}.log &> /dev/null
    fi
}

function install_pack()
{
    # Varables
    currentDate=$(date +"%F") # Date
    pacman="apt-get"

    # BEGIN
    log_dir
    if [ $# -eq 0 ]; then
        echo "Nie podałeś żadnego pakietu do instalacji" | tee -a ./log/log_${currentDate}.log &> /dev/null
        show_message WARNING "Nie podałeś zadnego pakietu do instalacji"

        exit 1

    else
        sudo $packman update | tee -a ./log/log_${currentDate}.log &> /dev/null
        for install in "$@"
        do
            dpkg -s $install &> /dev/null
            if [ $? -eq 0 ]; then
                echo "Pakiet $install jest już zainstalowany. Nie będę go instalował!" | tee -a ./log/log_${currentDate}.log &> /dev/null
                show_message INFO "Pakiet $install jest już zainstalowany"
            else
                echo "Pakiet $install nie jest zainstalowany. Nastapi jego instalacja" | tee -a ./log/log_${currentDate}.log &> /dev/null
                show_message INFO "Nastapi instalacja pakietu $install"
                sudo $packman install $install | tee -a ./log/log_${currentDate}.log &> /dev/null
                    if [ $? -eq 0 ]; then
                        echo "Pakiet $install zosatła poprawnie zainstalowany" | tee -a ./log/log_${currentDate}.log &> /dev/null
                        show_message OK "Pakiet $install został zainstalowany poprawnie"
                    else
                        echo "Problem z instalacją pakietu sprawdz wyżej." | tee -a ./log/log_${currentDate}.log &> /dev/null
                        show_message WARNING "Coś przy instalacji $install poszło nie tak, sprawdz log"
                    fi
                sudo $pacman install -f | tee -a ./log/log_${currentDate}.log &> /dev/null
            fi
        done
        sudo $pacman autoremove
    fi

    # END
}

function install_webmin()
{
    log_dir
    dpkg -s wget &> /dev/null
    if [ $? -eq 0 ]; then
        echo "Pakiet wget zlokalizowany. Nastapi pobranie webmin." | tee -a ./log/log_${currentDate}.log &> /dev/null
        mkdir ./temp_download
        if [ -d "./temp_download" ]; then
            wget -O ./temp_download/webmin.deb http://www.webmin.com/download/deb/webmin-current.deb | tee -a ./log/log_${currentDate}.log &> /dev/null
        fi
        if [ -e "./temp_download/webmin.deb" ]; then
            show_message OK "Pakiet webmin pobrany - przystepuje do instalacji."
            sudo dpkg -i ./temp_download/webmin.deb | tee -a ./log/log_${currentDate}.log &> /dev/null
            sudo apt-get install -f | tee -a ./log/log_${currentDate}.log &> /dev/null
            echo "Webmin zainstalowany" | tee -a ./log/log_${currentDate}.log &> /dev/null
            show_message OK "Pakiet Webmin zainstalowany."
        else
            echo "Plik webmin.deb nie istnieje, plik został zle pobrany - sprzwdz swoje łacze insternetowe." | tee -a ./log/log_${currentDate}.log &> /dev/null
            show_message ERROR "Webmin nie zainstalowany, pakiet .deb nie zlokalizowany."
        fi
        show_message INFO "Sprzatanie po czynnościach związanych z aktualizacją."
        echo "Sprzatam - katalog ./temp_download" | tee -a ./log/log_${currentDate}.log &> /dev/null
        rm -rf ./temp_download | tee -a ./log/log_${currentDate}.log &> /dev/null  
    fi
}