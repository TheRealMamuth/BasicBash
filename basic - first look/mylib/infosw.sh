#!/bin/bash

# Functions

function show_message()
{
    # Varables
    RED="\e[0;31m"
    GREEN="\e[0;32m"
    BLUE="\e[0;34m"
    NC="\e[0m"

    # BEGIN

    # Informacje o wymaganych dwóch argumentach
    # Information about the required two arguments
    if [ $# -lt 2 ]; then
        echo -e "${BLUE}WARNING: ${GREEN}$0 ${BLUE}wymagane są argumenty 2:$NC ${RED}typ_błedu$NC, ${RED}wiadomość$NC"
        exit 1
    fi

    case "$1" in
        # ERROR "Twoja wiadomość"
        # WARNING "Twoja wiadomość"
        # OK "Twoja wiadomość"
        # INFO "Twoja wiadomość"

        # ERROR "Your message"
        # WARNING "Your message"
        # OK "Your message"
        # INFO "Your message"
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