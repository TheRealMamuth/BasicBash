#!/bin/bash -       
#title           : my_user
#description     : A script that automatically creates a user / users
#author		     : Piotr "TheRealMamuth" Kośka
#date            : 24.02.2018
#version         : v1.0   
#usage		     :
#notes           :
#bash_version    : 4.4.12(1)-release
#editor          : visual studio code
#==============================================================================

function show_menu()
{
# Opcje dla pętli select.
# Options for the select loop.
options="\"Dodaj użytkownika\" \"Pokaż użytkowników\" \"Wyjście\""
# Nadajmy troche wyrazu naszemu select.
# Let's give a little expression to our select.
PS3='Wybierz opcję: '

# By uniknąć łamania spacji i tworzenia innych zmiennych.
# To avoid breaking spaces and creating other variables.
eval set $options

# Nasz select.
# Our select.
select option in "$@"
do
    # case
    case "$option" in
        # Opcja dla wartości "Dodaj użytkownika".
        # Option for "Add user" value.
        "Dodaj użytkownika")
            # Pobierz imie od użytkownika
            # Get the name from the user
            read -p "Podaj swoje imię: " name
            # Pobierz nazwisko od użytkownika
            # Get the last name from the user
            read -p "Podaj swoje nazwisko: " surname
            # Odwołanie do funkcji
            # A reference to a function
            create_user_now $name $surname
            ;;
        # Opcja dla wartości "Pokaż użytkowników".
        # Option for the "Show Users" value.
        "Pokaż użytkowników")
            echo "Lista aktualnych użytkowników:"
            awk -F: '($3 >= 1000) {printf "%s:\n",$1}' /etc/passwd
            read -n 1 -s -r -p "Naciśnij dowolny klawisz by kontynuować..."
            ;;
        # Po Prostu wyjście.
        # Simply exit.
        "Wyjście")
            exit 0
            ;;
    esac
done
# Komunikat końcowy.
# Final message.
echo "Wyjście ze skryptu."
}

function create_user_now()
{
    # Sprawdzanie ile argumentów zostało przekazanych do sunkcji.
    # Checking how many arguments have been passed to the sunkcji.
    if [ $# -eq 2 ]; then
        # Imię małymi literami.
        # Name in lower case letters.
        user_name=$(echo $1 | tr [:upper:] [:lower:])
        # Nazwisko małymi.
        # Surname, small.
        user_surname=$(echo $2 | tr [:upper:] [:lower:])
        # Wydobywamy pierwszą literę z imienia.
        # Extract the first letter by name.
        oneletter=$(echo $user_name | cut -c 1)
        # Tworzymy konto
        # We create an account
        account=$oneletter$user_surname
    else
        # Jeden argument, dane z pliku już sformatowane.
        # One argument, data from a file already formatted.
        account=$1
    fi

    # Dwóch użytkowników o takiej samej nazwie nie stworzę więc trzeba to sprawdzić.
    # Two users with the same name do not create so you have to check it out.
    egrep "^$account" /etc/passwd >/dev/null

    if [ $? -eq 0 ]; then
        # Użytkownik taki już istnieje. Nie możemy utworzyć otakiej samej nazwie. Musimy utworzyć troche inne konto dodając liczbę na koncu.
        # Such user already exists. We can not create the same name. We need to create a different account by adding the number at the end.
        echo "Użytkownik: $account istnieje."
        echo "Nie można dodać konta. Generacja nowej nazwy!"
        # Definiowanie auto numeracji.
        # Define auto numbering.
        addnumber=1
        # Sprawdzamy by wejści do pętli while.
        # We check to enter the while loop.
        egrep "^$account" /etc/passwd >/dev/null
        while [ $? -eq 0 ]; do
            # Inkrementacja.
            # Increment.
            addnumber=$((addnumber+1))
            # Konto tymczasowe też trzeba zweryfikować czy nie powtórzy się z już istniejącym nowo utworzonym
            # Temporary account also needs to be verified if it will not happen again with already existing newly created one
            tmp_account=$account$addnumber
            egrep "^$tmp_account" /etc/passwd >/dev/null
        done
        account=$tmp_account
    fi

    # Tworzymu konto i ustawiamy hasło oraz wymuszamy jego zmiane podczas pierwszego logowania.
    # Create your account and set a password and force it to be changed during the first login.
    path_account=/home/$account
    adduser $account --home $path_account --gecos "$name $surname,,,," --disabled-password
    echo "$account:$account" | sudo chpasswd >/dev/null
    chage -d 0 $account

    egrep "^$account" /etc/passwd >/dev/null
    if [ $? -eq 0 ]; then
        echo "Użytkownik został poprawnie założony."
    fi

    # Zapis danych do pliku w celach sprawozdawczych. Swoisty log.
    # Writing data to a file for reporting purposes. A special log.
    echo "${account}:${account}" | tee -a list_of_user.txt>/dev/null 

}

function create_special_user()
{
if [ $# -ge 2 ]; then
    # Imię i Nazwisko jako parametr.
    # Name and Surname as a parameter.
    create_user_now $1 $2
elif [ $# -eq 1 ]; then
    # Jedna opcja zatem traktuj jako plik
    # Treat one option as a file
    if [ -e "$1" ]; then
        # Plik istnieje.
        # File exists.
        if file "$1" | grep -q text$; then
            # Jest to tekst.
            # This is text.
            filename="$1"
            while IFS='' read -r line || [[ -n "$line" ]]; do
                # Przejdź do działania na każdej lini $line
                # Go to action on every $ line
                username="$line"
                create_user_now $username
            done < $filename
        else
            # File nie uznaje tego za tekst.
            # File does not recognize this as text.
            echo "Nie jest to typowy plik tekstowy!"
            exit 1
        fi
    else
        # Plik nie istnieje.
        # File does not exist.
        echo "Plik o podanej nazwie ${1} nie instanieje!"
        exit 2
    fi
else
    # Jak nie większe lub równe od dwóch i nie równe jeden czyli zero - wyswietlamy opcje.
    # How not greater than or equal to two and not equal one or zero - we display options.
    show_menu
fi
}