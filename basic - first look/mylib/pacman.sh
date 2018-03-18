#!/bin/bash -       
#title           : pacman
#description     : Very simple package manager
#author		     : Piotr "TheRealMamuth" Kośka
#date            : 24.02.2018
#version         : v1.0   
#usage		     :
#notes           :
#bash_version    : 4.4.12(1)-release
#editor          : visual studio code
#==============================================================================

function sws_install_depending()
{
    global_log="log"
    local pac_man='apt'
    local iitem=1
    if [ $# -eq 0 ]; then
        echo "Nie podałeś żadnego pakietu do instalacji." |& tee -a ./$global_log &> /dev/null
        show_message ERROR "Nie podałeś zadnego pakietu do instalacji!"
        exit 1
    else
        for install in "$@"; do
            dpkg -s $install &> /dev/null
            if [ $? -eq 0 ]; then
                echo "Pakiet $install jest już zainstalowany. Nie będę go instalował!" |& tee -a ./$global_log &> /dev/null
                show_message INFO "Pakiet $install jest już zainstalowany. Nie ędę go instalował!"
            else
                echo "Pakiet $install nie jest zainstalowany. Nastapi jego instalacja..." |& tee -a ./$global_log &> /dev/null
                show_message INFO "Pakiet $instal nie jest zainstalowany. Nastapi jego instalacja... (Pakiet[${iitem}]: $install)"
                sudo $pac_man install $install -y |& tee -a ./$global_log &> /dev/null
                    if [ $? -eq 0 ]; then
                        echo "Pakiet $install zosatła poprawnie zainstalowany." |& tee -a ./$global_log &> /dev/null
                        show_message OK "Pakiet $install został zainstalowany poprawnie."
                    else
                        echo "Problem z instalacją pakietu [${install}] sprawdz wyżej." |& tee -a ./$global_log &> /dev/null
                        show_message WARNING "Coś przy instalacji pakietu $install poszło nie tak, sprawdz ./${global_log}"
                    fi
                sudo $pacman install -f |& tee -a ./$global_log &> /dev/null
            fi
            ((iitem++))
        done
    fi
}