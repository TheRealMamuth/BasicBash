#!/usr/bin/env bash

# Zadanie 4. Lista inteferjsów sieci --------------------------------------------------------------------------------

# Interfejsy sieciowe na podstawie ip.
# Network interfaces based on ip.
echo "Wykaz wszystkich interfejsów sieciowych:" | tee -a Zadanie.txt
ip link show | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# Z informacją czy jest UP czy DOWN.
# With information whether it is UP or DOWN.
echo "Wykaz interfejsów sieciowych (nazwy) oraz czy jest UP / DOWN:" | tee -a Zadanie.txt
ip -o link show | awk '{print $2,$9}' | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# Same nazwy interfejsów.
# Same interface names.
echo "Wykaz interfejsów sieciowych - same nazwy:" | tee -a Zadanie.txt
ip -o link show | awk -F': ' '{print $2}' | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# Lista interfejsów na podstawie Kernel Interface Table.
# List of interfaces based on the Kernel Interface Table.
echo "Lista interfejsów sieciowych widzianych przez Kernel:" | tee -a Zadanie.txt
netstat -i | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# Na podstwie polecenia ifconfig z parametrem -a.
# Based on the ifconfig command with the -a parameter.
echo "Wykaz wszystkich interfejsów na podstawie ifconfig:" | tee -a Zadanie.txt
/sbin/ifconfig -a | tee -a Zadanie.txt
ifconfig -a | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# Lista interfejsów.
# List of interfaces.
echo "Same nazwy interfejsów:" | tee -a Zadanie.txt
ifconfig -a | sed 's/[ \t].*//;/^$/d' | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# Same nazwy interfejsów oprócz pętli zwrotne (lo)
# Same interface names in addition to loops (lo)
echo "Same nazwy interfejsów oprócz pętli zwrotne (lo):" | tee -a Zadanie.txt
ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d' | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# Nazwy interfejsów posortowane alfabetycznie i z wartościami unikatowymi
# Interface names sorted alphabetically and with unique values
echo "Nazwy interfejsów posortowane alfabetycznie i z wartościami unikatowymi:" | tee -a Zadanie.txt
ifconfig | cut -c 1-8 | sort | uniq -u | tee -a Zadanie.txt
echo "" | tee -a Zadanie4.txt

echo "Nazwy interfejsów posortowane alfabetycznie i z wartościami unikatowymi:" | tee -a Zadanie.txt
ifconfig | expand | cut -c1-8 | sort | uniq -u | awk -F: '{print $1;}' | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# Tu kombo lista interfejsów z nazwami oraz adresami IPv4 i IPv6.
# Here is a combo list of interfaces with names and IPv4 and IPv6 addresses.
echo "Tu wykorzytsanie petli for i nazwa interfejsów z adresami IPv4 i IPv6:" | tee -a Zadanie.txt
for i in $(ip ntable | grep dev | sort -u | awk '{print $2}'); do echo "Interfejs sieciowy: "$i | tee -a Zadanie.txt; ifconfig $i | grep inet | sed -e 's/\<inet\>/IPv4:/g' | sed -e 's/\<inet6\>/IPv6:/g' | awk 'BEGIN{OFS="\t"}{print $1, $2}' | tee -a Zadanie.txt; done
echo "" | tee -a Zadanie.txt

# Linux wszystko w sobie identyfikuje jako plika, a zatem zobaczmy katalog /sys/class/net
# Linux identifies everything as a file, so let's see the directory / sys / class / net
echo "Lista podłaczonych urządzeń:" | tee -a Zadanie.txt
ls /sys/class/net | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

read -n 1 -s -r -p "Naciśnij dowolny klawisz by kontynuować."
echo ""