# Zadanie 7. Punkty montowania systemu (df -h), zajętość dysku w % ( jak wyżej )
echo "Wszytskie informacje o zajętości rozmierze zajętości w procentach przedstawiony w sposób --human (lidzki):" | tee -a Zadanie7.txt
df -h | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

#
echo "Jak wyżej tylko z podsumowaniem tootal pod spodem:" | tee -a Zadanie.txt
df -h --total | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

#
echo "Nazwa udziału i punk montowania tego udziału:" | tee -a Zadanie.txt
df -h | awk '{ print $1 " " $6}' | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

#
echo "Informacja o Filesystem i opcji mount:" | tee -a Zadanie.txt
df -h | grep -vE '^tmpfs|cdrom' | awk '{ print $1 " " $6}' | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

#
echo "Podobnie ja z -h tylko z wartościami kilo:" | tee -a Zadanie.txt
df -k | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

#
echo "Tak jak z -h tylko dzielnik jest 1000:" | tee -a Zadanie.txt
df -H | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

#
echo "Informacja o udziale procentowym, filesystem, montowaniu:" | tee -a Zadanie.txt
df -H | grep -vE '^tmpfs|cdrom' | awk '{ print $5 " " $1 " " $6 }' | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# --Jest to swoisty przerywnik by nie latać po całej konsoli
read -n 1 -s -r -p "Naciśnij dowolny klawisz by kontynuować."
# -- Pusta linia po prostu. Długo by wyjaśniać, jak ją usuniesz to zobaczysz :) ale lepiej jak zostanie.
echo ""