#!/bin/bash
#title           : 
#description     : 
#author		     : Piotr "TheRealMamuth" Kośka
#date            : 04.03.2018
#version         : v1.0   
#usage		     :
#notes           :
#bash_version    : 4.4.12(1)-release
#editor          : visual studio code
#==============================================================================

# Lib
. ../lib/infoshow.sh

# Global Varable
global_log="install.log"

# Function

function sws_update()
{
    show_message INFO "Rozpoczynam aktualizacje systemu"
    echo "-------------------------AKTUALIZACJA--------------------------" |& tee -a ./$global_log
    sudo apt update |& tee -a ./$global_log
    sudo apt upgrade -y |& tee -a ./$global_log
    echo "-------------------------AKTUALIZACJA--------------------------" |& tee -a ./$global_log
    echo "" |& tee -a ./$global_log
}

function sws_install_depending()
{
    local pac_man='apt'
    local iitem=1
    if [ $# -eq 0 ]; then
        echo "Nie podałeś żadnego pakietu do instalacji." |& tee -a ./$global_log &> /dev/null
        show_message ERROR "Nie podałeś zadnego pakietu do instalacji!"
        exit 1
    else
        sws_update
        for local install in "$@"; do
            dpkg -s $install &> /dev/null
            if [ $? -eq 0 ]; then
                echo "Pakiet $install jest już zainstalowany. Nie będę go instalował!" |& tee -a ./$global_log &> /dev/null
                show_message INFO "Pakiet $install jest już zainstalowany. Nie ędę go instalował!"
            else
                echo "Pakiet $install nie jest zainstalowany. Nastapi jego instalacja..." |& tee -a ./$global_log &> /dev/null
                show_message INFO "Pakiet $instal nie jest zainstalowany. Nastapi jego instalacja... (Pakiet[${iitem}]: $install)"
                sudo $pac_man install $install -y |& tee -a ./$global_log &> /dev/null
                    if [ $? -eq 0 ]; then
                        echo "Pakiet $install zosatła poprawnie zainstalowany." |& tee -a ./$global_log &> /dev/null
                        show_message OK "Pakiet $install został zainstalowany poprawnie."
                    else
                        echo "Problem z instalacją pakietu [${install}] sprawdz wyżej." |& tee -a ./$global_log &> /dev/null
                        show_message WARNING "Coś przy instalacji pakietu $install poszło nie tak, sprawdz ./${global_log}"
                    fi
                sudo $pacman install -f |& tee -a ./$global_log &> /dev/null
            fi
            ((iitem++))
        done
    fi
}

function config_proftp()
{
#   Generacja certyfikatu dla ftp.
    sudo mkdir /etc/proftpd/ssl
    sudo openssl req -new -x509 -days 365 -nodes -out /etc/proftpd/ssl/proftpd.cert.pem -keyout /etc/proftpd/ssl/proftpd.key.pem
    sudo chmod 600 /etc/proftpd/ssl/proftpd.*

#   Welcome message - wiadomość powitalna.
    sudo cat > /etc/proftpd/welcome.msg << EOF

Witaj na servere ftp.

EOF

#   Konfiguracja proftpd jest w pliku: /etc/proftpd/proftpd.conf
#   Kopia pliku konfiguracyjnego.
    sudo cp /etc/proftpd/proftpd.conf /etc/proftpd/proftpd_backup.conf

#   Dostęp do FTPS w katalogu domowym.
    sudo sed '/# DefaultRoot/ c\ DefaultRoot ~' /etc/proftpd/proftpd.conf | sudo tee /etc/proftpd/proftpd_new.conf
    sudo mv /etc/proftpd/proftpd_new.conf /etc/proftpd/proftpd.conf

#   Wyłaczenie IPv6 dla bezpieczeństwa.
    sudo sed '/UseIPv6/ c\ UseIPv6 off' /etc/proftpd/proftpd.conf | sudo tee /etc/proftpd/proftpd_new.conf
    sudo mv /etc/proftpd/proftpd_new.conf /etc/proftpd/proftpd.conf

#   Zmiana portu z 21 na 50021.
    sudo sed '/Port				21/ c\ Port 21' /etc/proftpd/proftpd.conf | sudo tee /etc/proftpd/proftpd_new.conf
    sudo mv /etc/proftpd/proftpd_new.conf /etc/proftpd/proftpd.conf

#   Właczenie dodatkowego loga.
    sudo sed '/#UseLastlog on/ c\ UseLastlog on' /etc/proftpd/proftpd.conf | sudo tee /etc/proftpd/proftpd_new.conf
    sudo mv /etc/proftpd/proftpd_new.conf /etc/proftpd/proftpd.conf

#   Blokowanie logowania na root.
    sudo echo '# Zablokowanie logowania jako root' | sudo tee -a /etc/proftpd/proftpd.conf
    sudo echo 'RootLogin off' | sudo tee -a /etc/proftpd/proftpd.conf
#   Połaczenie szyfrowane.
    sudo echo '# Aktywowanie FTPS SSL/TLS' | sudo tee -a /etc/proftpd/proftpd.conf
    sudo echo 'Include /etc/proftpd/tls.conf' | sudo tee -a /etc/proftpd/proftpd.conf

#   Kopia ustawień.
    sudo mv /etc/proftpd/tls.conf /etc/proftpd/tls_backup.conf

#   Plik konfiguracyjny tls.conf
    cat > ./tls.conf << EOF
# Proftpd sample configuration for FTPS connections.
#
# Note that FTPS impose some limitations in NAT traversing.
# See http://www.castaglia.org/proftpd/doc/contrib/ProFTPD-mini-HOWTO-TLS.html
# for more information.
#

<IfModule mod_tls.c>
TLSEngine                               on
TLSLog                                  /var/log/proftpd/tls.log
TLSProtocol                             SSLv23
#
# Server SSL certificate. You can generate a self-signed certificate using 
# a command like:
#
# openssl req -x509 -newkey rsa:1024 \
#          -keyout /etc/ssl/private/proftpd.key -out /etc/ssl/certs/proftpd.crt \
#          -nodes -days 365
#
# The proftpd.key file must be readable by root only. The other file can be
# readable by anyone.
#
# chmod 0600 /etc/ssl/private/proftpd.key 
# chmod 0640 /etc/ssl/private/proftpd.key
# 
TLSRSACertificateFile                   /etc/proftpd/ssl/proftpd.cert.pem
TLSRSACertificateKeyFile                /etc/proftpd/ssl/proftpd.key.pem
#
# CA the server trusts...
#TLSCACertificateFile 			 /etc/ssl/certs/CA.pem
# ...or avoid CA cert and be verbose
TLSOptions                      NoCertRequest EnableDiags 
# ... or the same with relaxed session use for some clients (e.g. FireFtp)
#TLSOptions                      NoCertRequest EnableDiags NoSessionReuseRequired
#
#
# Per default drop connection if client tries to start a renegotiate
# This is a fix for CVE-2009-3555 but could break some clients.
#
TLSOptions 							AllowClientRenegotiations
#
# Authenticate clients that want to use FTP over TLS?
#
TLSVerifyClient                         off
#
# Are clients required to use FTP over TLS when talking to this server?
#
TLSRequired                             on
#
# Allow SSL/TLS renegotiations when the client requests them, but
# do not force the renegotations.  Some clients do not support
# SSL/TLS renegotiations; when mod_tls forces a renegotiation, these
# clients will close the data connection, or there will be a timeout
# on an idle data connection.
#
#TLSRenegotiate                          required off
</IfModule>
EOF

    sudo cp ./tls.conf /etc/proftpd/tls.conf

#   Restart usługi FTP
# 	sudo systemctl restart proftpd
    sudo /etc/init.d/proftpd restart

}

function config_apache()
{
    local apachePath=/etc/apache2
    sudo a2enmod userdir |& tee -a log$currentDate.log
#   Plik konfiguracyjny znajduje się /etc/apache2/mods-available/userdir.conf nie ma potrzeby go zmieniać.

    touch httpd.conf
    cat > httpd.conf << EOF
<Directory /var/www/>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
EOF
    sudo mv httpd.conf /etc/apache2/conf-available/

#   By działało hasło na folder www.
    sudo a2enconf httpd |& tee -a log$currentDate.log

#   Aktywacja PHP dla /home/*/public_html
    sudo sed '/php_admin_flag engine Off/ c\        php_admin_flag engine On' $apachePath/mods-available/php7.0.conf | sudo tee $apachePath/mods-available/php7.0.conf.new
    sudo mv $apachePath/mods-available/php7.0.conf $apachePath/mods-available/php7.0.conf.bak
    sudo mv $apachePath/mods-available/php7.0.conf.new $apachePath/mods-available/php7.0.conf

#   Dla Apache
    mkdir apachecert |& tee -a log$currentDate.log
#   W pierwszej kolejności generujemy 4096-bit długi klucz RSA dla naszego centrum (root CA) i zapisujemy go w pliku ca.key:
    sudo openssl genrsa -out apachecert/ca.key 4096
#   Następnie tworzymy własny samodzielnie podpisany przez root CA certyfikat o nazwie ca.crt
    sudo openssl req -new -x509 -days 3650 -key apachecert/ca.key -out apachecert/ca.crt
#   Tworzymy klucz dla usługi (w tym przypadku q.pem):
    sudo openssl genrsa -out apachecert/q.pem 1024
#   Kolejnym etapem jest generowanie żądania podpisu.
    sudo openssl req -new -key apachecert/q.pem -out apachecert/q.csr
#   Jako CA podpisujemy przygotowane żądanie i tworzymy q-cert.pem (podpis) z podpisem na 10 lat oraz generowanie numeru seryjnego dla wykonanego podpisu.
    sudo openssl -x509 -req -in apachecert/q.csr -out apachecert/q-cert.pem -sha1 -CA apachecert/ca.crt -CAkey apachecert/ca.key -CAcreateserial –days 3650
#   Otrzymany podpis sklejamy z generowanym kluczem w jeden plik zawierajacy certyfikat usługi i podpis CA tego certyfikatu.
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

}

function main()
{
    sws_install_depending unzip openssl apache2 php7.0 proftpd
}