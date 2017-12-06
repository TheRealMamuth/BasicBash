#!/usr/bin/env bash

# [EN] Variables.
# [PL] Zmienne.
numer = 0

# [EN] The command below shows a lot of useful operating system information.
# [EN] In addition, we will use the echo command to fine-tune the data in the console and in the file.
# [PL] Polecenie poniżej wyśietli wiele przydatnych informacji o systemie operacyjnym.
# [PL] Dodatkowo użyjemy polecenia echo w celu ładniejszej przezentacji danych w konsoli oraz w pliku.
((numer+=1))
echo $numer". Important information about the system: " | tee Zadanie1.txt
uname -a | tee -a Zadanie1.txt
echo "" | tee -a Zadanie1.txt # [PL] Pusta linia | [EN] Empty line.

# [EN] Information only about kernel (name, release) and platform (32/64 bit).
# [PL] Informacja tylko o kernelu (nazwa, wydanie) i platformie (32/64 bit).
((numer+=1))
echo $numer". Information about the kernel (name, release) and platform: " | tee -a Zadanie1.txt
uname -mrs | tee -a Zadanie1.txt
echo "" | tee -a Zadanie1.txt # [PL] Pusta linia | [EN] Empty line.

# [EN] Information only about the kernel itself (release).
# [PL] Informacja tylko o samym kernelu (wydaniu).
((numer+=1))
echo $numer". Information about the kernel itself (version):" | tee -a Zadanie1.txt
uname -r | tee -a Zadanie1.txt
echo "" | tee -a Zadanie1.txt # [PL] Pusta linia | [EN] Empty line.

# [EN] Distribution information.
# [PL] Informacja o dystrybyucji.
((numer+=1))
echo $numer". Distribution information with two commands:" | tee -a Zadanie1.txt
# [EN] Here we retrieve the information and pass it to the pipe egrep (which cuts from # to the next 100)
# [PL] Tu mamy pobranie informacji i przekazanie ich do potoku | egrep (który wycina od znaku # do 100 następnych)
uname -a | egrep -Eo '#.{1,100}' | tee -a Zadanie1.txt
uname -v | tee -a Zadanie1.txt
echo "" | tee -a Zadanie1.txt # [PL] Pusta linia | [EN] Empty line.

# [EN] Distribution information, release version, os.
# [PL] Informacja o dystrybucji, wersji wydaniu, typie os.
((numer+=1))
echo $numer". Distribution information, release version, os type:" | tee -a Zadanie1.txt
# [EN] We retrieve information from files.
# [PL] Pobieramy informacje z plików.
cat /etc/issue.net | tee -a Zadanie1.txt
cat /proc/sys/kernel/{ostype,osrelease,version} | tee -a Zadanie1.txt
echo "" | tee -a Zadanie1.txt # [PL] Pusta linia | [EN] Empty line.

# [EN] Press to continue.
# [PL] Naciśnij by kontynuować.
read -n 1 -s -r -p "Naciśnij dowolny klawisz by kontynuować."
echo ""