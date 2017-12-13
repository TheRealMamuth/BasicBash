#!/usr/bin/env bash

# Zadanie 3. Lista grup ---------------------------------------------------------------------------------------------
# Lista grup na podstawie pliku /etc/group
# List of groups based on the / etc / group file
echo "Korzystamy z pliku /etc/group:"
cut -d : -f 1 /etc/group | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# To samo co powyżej.
# Same as above.
echo "Tu tak samo jak powyżej z wykorzystaniem awk:"
awk -F ':' '{print $1}' /etc/group | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

read -n 1 -s -r -p "Naciśnij dowolny klawisz by kontynuować."
echo ""