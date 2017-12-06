#!/usr/bin/env bash

# Z pliku /etc/passwd.
echo "Lista użytkowników jest umieszczona w pliku /etc/passwd:" | tee Zadanie2.txt
# --Tu masz podział na kolumny po : i wypis pierwszej kolumny f1.
cut -d: -f1 /etc/passwd | tee -a Zadanie2.txt
awk -F':' '{ print $1}' /etc/passwd | tee -a Zadanie2.txt
echo "" | tee -a Zadanie2.txt

# Wszyscy uzytkownicy którzy mają folder /home.
echo "Użytkownicy którzy posiadają ścieżkę home:" | tee -a Zadanie2.txt
awk -F: '/\/home/ {printf "%s:%s\n",$1,$3}' /etc/passwd | tee -a Zadanie2.txt
echo "" | tee -a Zadanie2.txt

# Użytkownicy z UID >= 1000.
echo "Użytkownicy z UID >= 1000:" | tee -a Zadanie2.txt
awk -F: '($3 >= 1000) {printf "%s:%s\n",$1,$3}' /etc/passwd | tee -a Zadanie2.txt
echo "" | tee -a Zadanie2.txt

# Kombinacja dwóch powyższych.
echo "Kombinacja UID i home:" | tee -a Zadanie2.txt
awk -F: '/\/home/ && ($3 >= 1000) {printf "%s:%s\n",$1,$3}' /etc/passwd | tee -a Zadanie2.txt
echo "" | tee -a Zadanie2.txt

# Wszyscy z UID.
echo "Wszyscy uzytkownicy ze swoim UID:" | tee -a Zadanie2.txt
awk -F: '{printf "%s:%s\n",$1,$3}' /etc/passwd | tee -a Zadanie2.txt
echo "" | tee -a Zadanie2.txt

# Tu sprawdzamy ktory user może logowac sie do bash.
echo "Uzytkownicy z powłoką bash:" | tee -a Zadanie2.txt
cat /etc/passwd | grep "/bin/bash" | cut -d: -f1 | tee -a Zadanie2.txt
echo "" | tee -a Zadanie2.txt

# [EN] Press to continue.
# [PL] Naciśnij by kontynuować.
read -n 1 -s -r -p "Naciśnij dowolny klawisz by kontynuować."
echo ""