#!/bin/bash -       
#title           : Lesson07_process automation_solved
#description     : Creating a user using an automation script
#author		     : Piotr "TheRealMamuth" Kośka
#date            : 24.02.2018
#version         : v1.0   
#usage		     :
#notes           :
#bash_version    : 4.4.12(1)-release
#editor          : visual studio code
#==============================================================================

# [PL]

# Lekcja 7 - automatyzacja zadań.

# Zadanie pierwsze - Utworzyć skrypt który, będzie tworzył nam użytkownika:
# Recznie, wybrana opcja z menu.
# Jako parametr do skryptu w postaci imie i nazwisko.
# Z pliku tekstowego kilku użytkowników. (Przyjmiemy że plik tekstowy jest juz odpowiednio przygotowany czyli - użytkownik to pierwsza litera imienia reszta nazwisko. Każda linia w pliku to nowy użytkownik).

# [ENG]

# Lesson 7 - task automation.

# Task 1 - Create a script that will create a user:
# Manually, the option selected from the menu.
# As parameter to the script in the form of name and surname.
# From a text file of several users. (We assume that the text file is already properly prepared, ie the user is the first letter of the name, the rest surname, each line in the file is a new user).

# lib
. ../mylib/infoshow.sh
. ../mylib/my_user.sh

# BEGIN -------------------------------------------------------------------------------------------------------------------------------------------------------

main()
{
    if [ $(id -u) -eq 0 ]; then
        # Jesteś root lub podniosłeś uprawnienie przez sudo.
        # You are root or have raised the permission by sudo.
        create_special_user $1 $2
    else
        # You are not an authorized user. Only root can add a new user.
        show_message WARRNING "Nie jesteś uprawnionym użytkownikiem. Tylko root może dodać nowego użytkownika."
    fi
}

main $1 $2

# END ---------------------------------------------------------------------------------------------------------------------------------------------------------