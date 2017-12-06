#!/usr/bin/env bash

# Zadanie 3. Lista grup ---------------------------------------------------------------------------------------------
# Lista grup na podstawie pliku /etc/group
echo "Korzystamy z pliku /etc/group:"
cut -d : -f 1 /etc/group | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# To samo co powyżej.
echo "Tu tak samo jak powyżej z wykorzystaniem awk:"
awk -F ':' '{print $1}' /etc/group | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# --Jest to swoisty przerywnik by nie latać po całej konsoli
read -n 1 -s -r -p "Naciśnij dowolny klawisz by kontynuować."
# -- Pusta linia po prostu. Długo by wyjaśniać, jak ją usuniesz to zobaczysz :) ale lepiej jak zostanie.
echo ""