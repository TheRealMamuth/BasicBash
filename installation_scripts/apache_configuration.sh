#!/usr/bin/env bash

# Zmienne

# Zmienne Path
apachePath=/etc/apache2

# Aktywacja html dla każdego użytkownika - to jest moduł apacha2
sudo a2enmod userdir |& tee -a log$currentDate.log
# Plik konfiguracyjny znajduje się /etc/apache2/mods-available/userdir.conf nie ma potrzeby go zmieniać.

touch httpd.conf
cat > httpd.conf << EOF
<Directory /var/www/>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
EOF

sudo mv httpd.conf /etc/apache2/conf-available/

# By działało hasło na folder www.
sudo a2enconf httpd |& tee -a log$currentDate.log

# Aktywacja PHP dla /home/*/public_html
sudo sed '/php_admin_flag engine Off/ c\        php_admin_flag engine On' $apachePath/mods-available/php7.0.conf | sudo tee $apachePath/mods-available/php7.0.conf.new
sudo mv $apachePath/mods-available/php7.0.conf $apachePath/mods-available/php7.0.conf.bak
sudo mv $apachePath/mods-available/php7.0.conf.new $apachePath/mods-available/php7.0.conf

# Restart usługi apache2.
#	sudo systemctl restart apache2
sudo /etc/init.d/apache2 restart |& tee -a log$currentDate.log

# Generacja certyfikatów
# Dla FTP
#	sudo openssl req -x509 -newkey rsa:2048 -keyout /etc/ssl/private/proftpd.key -out /etc/ssl/certs/proftpd.crt -nodes -days 365
sudo mkdir /etc/proftpd/ssl
sudo openssl req -new -x509 -days 365 -nodes -out /etc/proftpd/ssl/proftpd.cert.pem -keyout /etc/proftpd/ssl/proftpd.key.pem
sudo chmod 600 /etc/proftpd/ssl/proftpd.*

# Dla Apache
mkdir apachecert |& tee -a log$currentDate.log
# W pierwszej kolejności generujemy 4096-bit długi klucz RSA dla naszego centrum (root CA) i zapisujemy go w pliku ca.key:
sudo openssl genrsa -out apachecert/ca.key 4096
# Następnie tworzymy własny samodzielnie podpisany przez root CA certyfikat o nazwie ca.crt
sudo openssl req -new -x509 -days 3650 -key apachecert/ca.key -out apachecert/ca.crt
# Tworzymy klucz dla usługi (w tym przypadku q.pem):
sudo openssl genrsa -out apachecert/q.pem 1024
# Kolejnym etapem jest generowanie żądania podpisu.
sudo openssl req -new -key apachecert/q.pem -out apachecert/q.csr
# Jako CA podpisujemy przygotowane żądanie i tworzymy q-cert.pem (podpis) z podpisem na 10 lat oraz generowanie numeru seryjnego dla wykonanego podpisu.
sudo openssl -x509 -req -in apachecert/q.csr -out apachecert/q-cert.pem -sha1 -CA apachecert/ca.crt -CAkey apachecert/ca.key -CAcreateserial –days 3650
# Otrzymany podpis sklejamy z generowanym kluczem w jeden plik zawierajacy certyfikat usługi i podpis CA tego certyfikatu.
sudo cat apachecert/q-cert.pem >> apachecert/q.pem

if [ -e "$apachePath/sites-available" ]; then
    sudo cp $apachePath/sites-available/default-ssl.conf $apachePath/sites-available/default-ssl.conf.bak |& tee -a log$currentDate.log
	sudo sed '/                SSLCertificateFile      /etc/ssl/certs/ssl-cert-snakeoil.pem/ c\                SSLCertificateFile      /etc/apache2/q.pem' $apachePath/sites-available/default-ssl.conf | sudo tee $apachePath/sites-available/default-ssl.conf.1
	sudo mv $apachePath/sites-available/default-ssl.conf $apachePath/sites-available/default-ssl.old |& tee -a log$currentDate.log
	sudo mv $apachePath/sites-available/default-ssl.conf.1 $apachePath/sites-available/default-ssl.conf |& tee -a log$currentDate.log
	sudo sed '/                SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key/ c\                #SSLCertificateKeyFile      /etc/ssl/private/ssl-cert-snakeoil.key' $apachePath/sites-available/default-ssl.conf | sudo tee $apachePath/sites-available/default-ssl.conf.1
	sudo mv $apachePath/sites-available/default-ssl.conf $apachePath/sites-available/default-ssl.old |& tee -a log$currentDate.log
	sudo mv $apachePath/sites-available/default-ssl.conf.1 $apachePath/sites-available/default-ssl.conf |& tee -a log$currentDate.log
else
    echo "Brak pliku - default-ssl.conf, nie kompletne." |& tee -a log$currentDate.log
fi

sudo cp apachecert/q.pem $apachePath/q.pem |& tee -a log$currentDate.log
sudo a2enmod ssl |& tee -a log$currentDate.log 
sudo a2ensite default-ssl |& tee -a log$currentDate.log
sudo /etc/init.d/apache2 restart |& tee -a log$currentDate.log