#!/usr/bin/env bash

# Zadanie 5. Procesy (ps)
# usługi, wraz ze informacją przez który proces została uruchomiona, nr. portu i czy usługa nasłuchuje (netstat -penault)
echo "Usługi, wraz ze informacją przez który proces została uruchomiona, nr. portu i czy usługa nasłuchuje" | tee -a Zadanie.txt
netstat -plnt | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# Lista wszystkich usług / services, + (plus) działa, - (minus) niedziała.
echo "Lista wszystkich usług / services, + (plus) działa, - (minus) niedziała." | tee -a Zadanie.txt
service --status-all | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# user
echo "" | tee -a Zadanie.txt
systemctl -l --type service --all | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

# root
echo "" | tee -a Zadanie.txt
sudo systemctl -r --type service --all | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

echo "Na podstawie skrtptów w katalogu /etc/init.d/" | tee -a Zadanie.txt
ls /etc/init.d/ | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

echo "Runlevel symlinks" | tee -a Zadanie.txt
ls /etc/rc*.d/ -la | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

#To see every process on the system using BSD syntax:
echo "Polecenie  PS" | tee -a Zadanie.txt
ps -aux | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

#To see every process running as root (real & effective ID) in user format:
echo "" | tee -a Zadanie.txt
ps -U root -u root -N | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

#pstree shows running processes as a tree.  The tree is rooted at either
#       pid  or  init  if  pid  is  omitted.   If a user name is specified, all
#       process trees rooted at processes owned by that user are shown.

#       pstree visually merges identical branches by  putting  them  in  square
#       brackets and prefixing them with the repetition count, e.g.
echo "" | tee -a Zadanie.txt
pstree | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

#To print a process tree:
echo "" | tee -a Zadanie.txt
ps -ejH | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

#To print a process tree:
echo "" | tee -a Zadanie.txt
ps axjf | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

#TCP and UDP.
echo "" | tee -a Zadanie.txt
sudo lsof -i -n -P | more | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

#TCP.
echo "" | tee -a Zadanie.txt
sudo lsof -i -n -P | grep TCP | more | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

#UDP.
echo "" | tee -a Zadanie.txt
sudo lsof -i -n -P | grep UDP | more | tee -a Zadanie.txt
echo "" | tee -a Zadanie.txt

read -n 1 -s -r -p "Naciśnij dowolny klawisz by kontynuować."
echo ""