#!/usr/bin/env bash

# Zadanie 7. Punkty montowania systemu (df -h), zajętość dysku w % 
# All information about the occupancy size occupied as a percentage is presented in a human way
echo "Wszytskie informacje o zajętości rozmierze zajętości w procentach przedstawiony w sposób ludzki:" | tee -a Zadanie7.txt
df -h | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# Jak wyżej tylko z podsumowaniem tootal pod spodem
# As above only tootal summary underneath
echo "Jak wyżej tylko z podsumowaniem tootal pod spodem:" | tee -a Zadanie.txt
df -h --total | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# Nazwa udziału i punk montowania tego udziału
# The name of the share and the point of mounting this share
echo "Nazwa udziału i punk montowania tego udziału:" | tee -a Zadanie.txt
df -h | awk '{ print $1 " " $6}' | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# Informacja o Filesystem i opcji mount
# Information about Filesystem and mount option
echo "Informacja o Filesystem i opcji mount:" | tee -a Zadanie.txt
df -h | grep -vE '^tmpfs|cdrom' | awk '{ print $1 " " $6}' | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# Podobnie ja z -h tylko z wartościami kilo
# Similarly, I am with -h only with kilo values
echo "Podobnie ja z -h tylko z wartościami kilo:" | tee -a Zadanie.txt
df -k | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# Tak jak z -h tylko dzielnik jest 1000
# Just like with -h only the divisor is 1000
echo "Tak jak z -h tylko dzielnik jest 1000:" | tee -a Zadanie.txt
df -H | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# Informacja o udziale procentowym, filesystem, montowaniu
# Percentage information, filesystem, mounting
echo "Informacja o udziale procentowym, filesystem, montowaniu:" | tee -a Zadanie.txt
df -H | grep -vE '^tmpfs|cdrom' | awk '{ print $5 " " $1 " " $6 }' | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

read -n 1 -s -r -p "Naciśnij dowolny klawisz by kontynuować."
echo ""