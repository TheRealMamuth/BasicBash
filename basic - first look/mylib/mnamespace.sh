#!/bin/bash -       
#title           : mnamespace
#description     : Functions that create namespace
#author		     : Piotr "TheRealMamuth" Kośka
#date            : 24.02.2018
#version         : v1.0   
#usage		     :
#notes           :
#bash_version    : 4.4.12(1)-release
#editor          : visual studio code
#==============================================================================

# lib
. ./infoshow.sh
. ./pacman.sh


# Pokazuj dostepne interfejsy sieciowe
# Show network interfaces - in default namespace (linux)
function show_interfaces()
{
    ip -o link show | awk '{print $2,$9}'
}

# Prosta funkcja "Pauza", kontynuacja na dowolny przycisk
# any button function
function press_any_key()
{
    read -n 1 -s -r -p "Naciśnij dowolny klawisz by kontynuować..."
}

# Funkcja usówa wszystkie namespace 
# clean namespace function
function clean_ns()
{
    for element in `ip netns list`; do
        sudo ip netns del $element
    done
}

# funkcja tworzy namespace
# create namespace function
function create_ns()
{
    if [ $# -eq 0 ]; then
#       
        show_message ERROR "Nie podałeś liczby tworzonych namespace wymagana liczba >=1."
        exit 1
    fi
#   Wyrażenie regularne. Sprawdza czy podany argument do funkcji jako $1 jest liczbą oraz czy jest wiekszy 0.
#   Regular expression. Checks whether the argument given to the function as $ 1 is a number and whether it is greater than 0.
    if [[ $1 =~ ^-?[0-9]+$ && $1 -ge 0 ]]; then
        for ((i=1, ii=1; i<=$1; i++)); do
#           Sprawdza czy dany namespace istnieje.
#           Check if namespace exists
            ls /var/run/netns/namespace$ii 2> /dev/null
            while [ $? -eq 0 ]; do
#               Jeżeli istnieje do inkrementuj.
#               If exists set ii++
                ((ii++))
                ls /var/run/netns/namespace$ii 2> /dev/null
            done
#           Tworzy name space.   
#           Create namespace. 
            sudo ip netns add namespace${ii}
            ((ii++))
        done
    else
#       Gdy nie podamy liczby
#       When we put someting else not number.
        show_message ERROR "Nie podałeś liczby >=1."
        exit 2
    fi   
}

# Akcje wykonywane w danym namespace
# Actions performed in given namespace
function action_namespace()
{
    local all_done=0
    while (( !$all_done )); do
#       Opcje dla select.
#       Options for select.
        actions_ns="\"Dodaj interfejs sieciowy\" \"Ustaw adres IP\" \"Wyczyść adres IP\" \"Wydaj komendę\" \"Wyjście\""
#       Indywidualny znak zachety.
#       Individual sign of incentives.
        PS3="[$option2]: "
#       Dany wybrany z opcji list_of_namespace()
#       Data selected from list_of_namespace ()
        ns=$option2
        eval set $actions_ns
        select action in "$@"
        do
            case "$action" in
                "Dodaj interfejs sieciowy")
#                   Wyświetla liste dostepnych interfejsów sieciowych oraz pozwala dodac wybrany do namespace.
#                   Displays a list of available network interfaces and allows you to add selected to namespace.
                    show_interfaces
                    echo "-----------------------------------------------------"
                    read -p "Wybierz interfejs: " if_set
                    sudo ip link set $if_set netns $ns 
                    break
                    ;;
                "Ustaw adres IP")
#                   Pozwala ustawić adresi ip na interfejsie sieciowym w danym name space.
#                   Allows you to set the IP address and p on the network interface in the given name space.
                    sudo ip netns exec $ns ip -o link show | awk '{print $2,$9}'
                    echo "-----------------------------------------------------"
                    read -p "Wybierz interfejs: " if_set
                    read -p "Podaj adres ip (np.: 10.10.10.10/24): " ip_set
                    sudo ip netns exec $ns ip a a $ip_set dev $if_set
                    sudo ip netns exec $ns ip l s dev $if_set up
                    break
                    ;;
                "Wyczyść adres IP")
#                   Pozwala zwolic adres ip interfejsu sieciowego w danym namespace.
#                   Allows you to enable the ip address of the network interface in the given namespace.
                    show_interfaces
                    echo "-----------------------------------------------------"
                    read -p "Wybierz interfejs: " if_set
                    sudo ip netns exec $ns ip a f dev $if_set
                    sudo ip netns exec $ns ip l s dev $if_set down
                    break
                    ;;
                "Wydaj komendę")
#                   Own command in namespace.
                    read -p "Podaj komendę (np.: ping 10.10.10.10):" my_command
                    sudo ip netns exec $ns $my_command
                    break
                    ;;
                "Wyjście")
                    local all_done=1
                    break
                    ;;
            esac
        done
    done
}

# funkcja tworzy prosty bridge ovs
# function creates a simple ovs bridge
function create_ovs()
{
    sudo ovs-vsctl add-br $1
}

# Funkcja dodaje port wewnetrzny do ovs
# The function adds the internal port to ovs
function create_internal_ovs_port()
{
    sudo ovs-vsctl add-port $2 $1 -- set Interface $1 type=internal
}

# Funkcja do wyświetlania namespace
# Function to display namespace
function list_of_namespace()
{
    local all_done=0
    while (( !$all_done )); do
        options2=""
        for element in `ip netns list; echo "exit"`; do
            options2="$options2 $element"
        done

        PS3='[namespace]: '

        eval set $options2

#       Dodatkowo gdy wybierzemy opcje wchodzi w interakcje z namespace.
#       In addition, when we select options interact with namespace.
        select option2 in "$@"
        do
            if [[ $option2 == "exit" ]]; then
                local all_done=1
                break
            fi
            if [[ $option2 == "$option2" ]]; then
                action_namespace $option2
                break
            fi
        done
    done
}

# funkcja main menu
# menu function
function main_menu()
{
#   Opcje dla pętli select.
#   Options for the select loop.
    options="\"Utwórz network namespace\" \"Pokaż namespace\" \"Wyczyść wszystkie namespace\" \"Dodaj interfejsy\" \"Utwórz ovs-switch\" \"Wydaj komendę\" \"Wyjście\""

#   By uniknąć łamania spacji i tworzenia innych zmiennych.
#   To avoid breaking spaces and creating other variables.
    eval set $options

    local all_done=0
    while (( !$all_done )); do
#       Nadajmy troche wyrazu naszemu select.
#       Let's give a little expression to our select.
        PS3='Wybierz opcję: '
#       Nasz select.
#       Our select.
        select option in "$@"
        do
            case "$option" in
                "Utwórz network namespace")
#                   Podanie liczby tworzonych name space.
#                   Specifying the number of names created space.
                    read -p "Podaj liczba namespace którą, mam utworzyć: " ns_number
                    create_ns $ns_number
                    break
                    ;;
                "Pokaż namespace")
#                   Menu listy namespace oraz interakcji z nimi.
#                   Menu namespace list and interact with them.
                    list_of_namespace
                    break
                    ;;
                "Wyczyść wszystkie namespace")
#                   Usówamy powstałe name space.
#                   We delete the resulting namespace.
                    clean_ns
                    break
                    ;;
                "Dodaj interfejsy")
#                   Dodajemy interfejs sieciowy (virtualny)
#                   We add a network interface (virtualny)
                    echo "Nazwy interfejsów sieciowych: "
                    show_interfaces
                    echo "------------------------------------------------"
                    read -p "Podaj nazwę interfejsu sieciowego: " tap_name
                    read -p "Wybierz bridge: " br_name
                    create_internal_ovs_port veth${tap_name} $br_name
                    break
                    ;;
                "Utwórz ovs-switch")
#                   Tworzymy bridge ovs.
#                   We create the ovs bridge.
                    read -p "Podaj nazwe twojego nowego ovs: " ovs_name
                    create_ovs $ovs_name
                    sudo ip l s dev $ovs_name up
                    break
                    ;;
                "Wydaj komendę")
#                   Możemy wydac proste komendy.
#                   Own command
                    read -p "CMD: " cmd
                    $cmd
                    break
                    ;;
                "Wyjście")
#                   Koniec skryptu.
#                   end script
                    local all_done=1
                    show_message OK "Zakończyłeś pracę z narzedziem namespace-creator create by Piotr 'TheRealMamuth' Kośka."
                    press_any_key
                    echo "Pa Pa."
                    break
                    ;;
                *)
                    show_message ERROR "Zły wybór opcji."
                    press_any_key
                    break
                    ;;
            esac
        done
    done
}

main()
{
    main_menu
}