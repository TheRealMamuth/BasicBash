#!/usr/bin/env bash

#ZADANIE - Przywitanie użytkownika „welcome message” i wyświetla info 
#- ostatnie logowanie
#- ip z jakiego się logowalo
#- dzisiejsza date
logowales_z=$(last -i | grep "$SUER" | grep -v "still" | grep -m1 "" | awk '{print $2}')
z_ip=$(last -i | grep "$SUER" | grep -v "still" | grep -m1 "" | awk '{print $3}')
data_ostatniego=$(last -i | grep "$SUER" | grep -v "still" | grep -m1 "" | awk '{print $4" "$5" "$6" "$7" "$8" "$9" "$10" "$11" "$12" "$13}')
bierzaca_data=$(date +"%F")
bierzacy_czas=$(date +"%T")

# Zmienne SQL 
sqluser="root" 
sqlpass="root"

# Witaj uzytkowniku.
echo "Witaj uzytkowniku $USER!"
echo "Ostatnie logowałeś się z: $logowales_z"
echo "Z adresu IP: $z_ip"
echo "Data ostatniego logowania: $data_ostatniego"
echo "Bierząca data: $bierzaca_data $bierzacy_czas"

#ZADANIE - Skrypt, który zakłada konta na podstawi imienia i nazwiska 
#       (format: mnowak, kzielinski tj. pierwsza litera imienia i nazwisko)
if [ $(id -u) -eq 0 ]; then
    
    # Skrypt możliwy do wywołania z parametrami ./bash2 imie nazwisko
    if [ $# -eq 2 ]; then
        imie=$1
        nazwisko=$2
    else
        read -p "Podaj swoje imie: " imie
        read -p "Podaj swoje nazwisko: " nazwisko
    fi

    #ZADANIE - Zapamiętuje numer pokoju (tak powiedział, może po prostu ma pamietac numer pokoju i tyle)
    read -p "Podaj numer pokoju: " numer_pokoj
    read -p "Podaj Telefon Pracowniczy: " telefon_praca
    read -p "Podaj Telefon Domowy: " telfon_domowy

    # Zmiana wielkich liter na małe.
    imie=$(echo $imie | tr [:upper:] [:lower:])
    nazwisko=$(echo $nazwisko | tr [:upper:] [:lower:])
    litera=$(echo $imie | cut -c 1)
    konto=$litera$nazwisko

    # Zmienna path do home danego usera
    path_konto=/home/$konto

    #ZADANIE - Sprawdza czy dany użytkownik istnieje i może wyświetlić jakąś informacje
    # Sprawdzenie czy użytkownik taki jest.
    egrep "^$konto" /etc/passwd >/dev/null

    if [ $? -eq 0 ]; then
        # Informacja o tym że uzytkownik istnieje.
        echo "Użytkownik: $konto istnieje."
        echo "Nie można dodać uzytkownika!"
        exit 1
    else
        # Dodanie uzytkownika na podstawie zebranych danych.
        adduser $konto --gecos "$imie $nazwisko,$numer_pokoj,$telefon_praca,$telfon_domowy,Uzytkownik utworzony przez skrypt" --disabled-password
        read -s -p "Podaj hasło dla użytkownika $konto: " haslo
        echo "$konto:$haslo" | sudo chpasswd >/dev/null
        pokoju=$(egrep "$konto" /etc/passwd | awk -F ":" '{print $5}' | awk -F "," '{print $2}')
        tel1=$(egrep "$konto" /etc/passwd | awk -F ":" '{print $5}' | awk -F "," '{print $3}')
        tel2=$(egrep "$konto" /etc/passwd | awk -F ":" '{print $5}' | awk -F "," '{print $4}')
        prawdziwy_uzytkownik=$(egrep "$konto" /etc/passwd | awk -F ":" '{print $5}' | awk -F "," '{print $1}')

        echo "Został utworzony uzytkownik: $konto ($prawdziwy_uzytkownik)"
        echo "Uzytkownik konta jest w pokoju: $pokoju"
        echo "Numer do tego pokoju to: $tel1"
        echo "Po za pracą znajdziesz go: $tel2"

        #Dla uztykownika zalozyk aliasy do polecen ll=ls-al. - w ubuntu juz jest.
        #-mogą być kwiatuszki etc krowa o czym ci mowilem jeden chuj.
        cat >> /home/$konto/.bashrc <<EOF
        
# aliasy
alias krowa='apt-get moo'

#Wadomość powitalna
logowales_z=\$(last -i | grep "\$SUER" | grep -v "still" | grep -m1 "" | awk '{print \$2}')
z_ip=\$(last -i | grep "\$SUER" | grep -v "still" | grep -m1 "" | awk '{print \$3}')
data_ostatniego=\$(last -i | grep "\$SUER" | grep -v "still" | grep -m1 "" | awk '{print \$4" "\$5" "\$6" "\$7" "\$8" "\$9" "\$10" "\$11" "\$12" "\$13}')
bierzaca_data=\$(date +"%F")
bierzacy_czas=\$(date +"%T")

# Witaj uzytkowniku.
echo "Witaj uzytkowniku \$USER!"
echo "Ostatnie logowałeś się z: \$logowales_z"
echo "Z adresu IP: \$z_ip"
echo "Data ostatniego logowania: \$data_ostatniego"
echo "Bierząca data: \$bierzaca_data \$bierzacy_czas"
        
EOF

        #- w jego katalogu zalozyc public.html i public_samba
        #- w public_html zalozyc katalog private.html
        mkdir /home/$konto/public_html
        mkdir /home/$konto/public_samba
        mkdir /home/$konto/public_html/private_html

        chmod 755 $path_konto/public_html
        chmod 777 $path_konto/public_samba
        chmod 755 $path_konto/public_html/private_html

        chown $konto:www-data $path_konto/public_html
        chown $konto:$konto $path_konto/public_samba
        chown $konto:www-data $path_konto/public_html/private_html
        touch $path_konto/public_html/private_html/.htaccess
        cat > $path_konto/public_html/private_html/.htaccess << EOF
AuthName "Podaj haslo do katalogu prywatnego"
AuthType Basic
AuthUserFile /home/$konto/public_html/private_html/.htpasswd
Require valid-user
EOF
        # Katalog na hasło.
        sudo htpasswd -b -c /home/$konto/public_html/private_html/.htpasswd $konto $haslo

        # Welcome message dla kazdego usera.
        touch $path_konto/welcome.msg
        cat > $path_konto/welcome.msg << EOF
WITAJ UŻYTKOWNIKU: $konto NA SERWERZE FTP by Michal Macibuch.
EOF

        # Baza danych dla użytkownika.
        mysql -u$sqluser -p$sqlpass <<MYSQL
CREATE USER '$konto'@'localhost' IDENTIFIED BY '$haslo';
GRANT USAGE ON *.* TO '$konto'@'localhost' REQUIRE NONE WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;
CREATE DATABASE IF NOT EXISTS $konto;
GRANT ALL PRIVILEGES ON $konto.* TO '$konto'@'localhost';
FLUSH PRIVILEGES;
MYSQL

        # Ustawienia plików.
        chmod 644 $path_konto/public_html/private_html/.htaccess
        chown $konto:www-data $path_konto/public_html/private_html/.htaccess
        chmod 644 $path_konto/public_html/private_html/.htpasswd
        chown $konto:www-data $path_konto/public_html/private_html/.htpasswd
        mkdir /var/www/html/$konto/
        chmod 755 /var/www/html/$konto
        chown $konto:www-data /var/www/html/$konto
        usermod -aG www-data $konto
        chgrp -R www-data /home/$konto/public_html
        find /home/$konto/public_html -type d -exec chmod g+rx {} +
        find /home/$konto/public_html -type f -exec chmod g+r {} +
        chown -R $konto /home/$konto/public_html/
        find /home/$konto/public_html -type d -exec chmod u+rwx {} +
        find /home/$konto/public_html -type f -exec chmod u+rw {} +
        find /home/$konto/public_html -type d -exec chmod g+s {} +
        ln -s /var/www/html/$konto /home/$konto/www_$konto

        mysql -u$konto -p$haslo $konto << EOF
CREATE TABLE $konto (counter INT(20) NOT NULL);
INSERT INTO $konto VALUES (0); 
EOF
        touch $path_konto/public_html/index.php
        cat > $path_konto/public_html/index.php << EOF
<?php
\$link = mysqli_connect("127.0.0.1", "$konto", "$haslo", "$konto");

if (!\$link) {
    echo "Blad: Brak polaczenia do MySQL." . PHP_EOL . "<br/>";
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL . "<br/>";
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL . "<br/>";
    exit;
}

echo "Sukces: Udało podłaczyć się do MySQL! Baza $konto jest." . PHP_EOL . "<br/>";
echo "Informacja o hoscie: " . mysqli_get_host_info(\$link) . PHP_EOL . "<br/>";

\$sql = "UPDATE $konto SET counter = counter +1";
if (\$link->query(\$sql) === TRUE) {
        /// echo "Yes";
} else {
        echo "No" . \$link->error;
}

\$sql = "SELECT counter FROM $konto";
\$result = \$link->query(\$sql);

while(\$row = \$result->fetch_assoc()) {
        echo "<br/>"."<h1>Liczba odwiedzin: " . \$row["counter"] . "</h1><br/>";
}

mysqli_close(\$link);
?>
EOF

    fi

else 
    echo "Tylko uzytkownik root ma prawo dodac uzytkownika do systemu"
    exit 2
fi