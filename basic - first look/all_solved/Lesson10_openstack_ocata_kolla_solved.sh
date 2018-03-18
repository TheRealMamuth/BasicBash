#!/bin/bash -       
#title           : 
#description     : 
#author		     : Piotr "TheRealMamuth" Kośka
#date            : 24.02.2018
#version         : v1.0   
#usage		     :
#notes           :
#bash_version    : 4.4.12(1)-release
#editor          : visual studio code
#==============================================================================

. ../mylib/infoshow.sh
. ../mylib/pacman.sh

function update()
{
    show_message INFO '----------- System update and upgrade: '
    sudo apt update && sudo apt upgrade -y
    show_message INFO '----------- End of update. -------------'
}

function show_interfaces()
{
    ip -o link show | awk '{print $2,$9}'
}

function set_network_interfaces()
{
    local all_exit=0
    while (( !$all_exit )); do
        local options="\"Set temporary\" \"Set permanently\" \"Exit\""
        local networkinterface=""
        local ipaddr=""
        local routeaddr=""
        local networkaddr
        echo "------------------------------------------------------"
        show_interfaces
        echo "------------------------------------------------------"
        eval set $options
        select option in "$@"; do
            case $option in
                "Set temporary")
                    read -p "Choose the network interface: " networkinterface
                    read -p "Enter the IP address with the mask (example: 192.168.1.1/24): " ipaddr
                    read -p "Enter the default route address: " routeaddr
                    read -p "Enter the IP of the network with the mask: " networkaddr
                    sudo ip a a $ipaddr dev $networkinterface
                    sudo ip l s dev $networkinterface up
                    sudo ip route add default via $routeaddr
                    sudo ip route add $networkaddr dev $networkinterface
                    break
                    ;;
                "Set permanently")
                    local all_done=0
                    while (( !$all_done )); do
                        local protocols="dhcp static manual exit"
                        echo "------------------------------------------------------"
                        show_interfaces
                        echo "------------------------------------------------------"
                        read -p "Choose the network interface: " networkinterface
                        sudo cat > /etc/network/interfaces << EOF
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback
EOF
                        select protocol in $protocols; do
                            case $protocol in
                                "dhcp")
                                    sudo cat > /etc/network/interfaces.d/$networkinterface << EOF
auto $networkinterface
iface $networkinterface inet dhcp
EOF
                                    break
                                    ;;
                                "static")
                                    read -p "Enter the IP address with the mask (example: 192.168.1.1/24): " ipaddr
                                    read -p "Enter netmask IP: " netmask
                                    read -p "Enter gateway IP: " gateway
                                    read -p "Enter dns server IP: " dnsip
                                    sudo cat > /etc/network/interfaces.d/$networkinterface << EOF
auto $networkinterface
iface $networkinterface inet static
    address $ipaddr
    netmask $netmask
    gateway $gateway
    dns-nameservers $dnsip
EOF
                                    break
                                    ;;
                                "manual")
                                    sudo cat > /etc/network/interfaces.d/$networkinterface << EOF
auto $networkinterface
iface $networkinterface inet manual
EOF
                                    break
                                    ;;
                                "exit")
                                    all_done=1
                                    clear
                                    sudo systemctl restart networking
                                    break
                                    ;;
                            esac
                        done
                    done
                    break
                    ;;
                "Exit")
                    local all_exit=1
                    break
                    ;;
            esac
        done
    done
}

function pip_iu()
{
    for install in "$@"; do
        show_message INFO "Begin installation of the pip package [${install}]:"
        sudo -H pip install -U $install
        show_message INFO "----- End of installation. -----"
    done
}

function globals_config_yml()
{
    echo << EOF
--EXAMPLE:
kolla_base_distro: "centos"
kolla_install_type: "binary"
openstack_release: "4.0.0"
kolla_internal_vip_address: "10.10.20.33"
kolla_external_vip_address: "10.10.20.30"
network_interface: "[first_nic_label]"
neutron_external_interface: "[second_nic_label]"
kolla_enable_tls_external: "yes"
kolla_external_fqdn_cert: "{{ nodeconfigdirectory }}/certificates/haproxy.pem"
EOF
sudo nano /etc/kolla/globals.yml
}

function init_runonce()
{
    echo << EOF
--EXAMPLE:
EXT_NET_CIDR='10.10.20.0/24'
EXT_NET_RANGE='start=10.10.20.110,end=10.10.20.254'
EXT_NET_GATEWAY='10.10.20.1'
EOF
sudo nano /usr/local/share/kolla-ansible/init-runonce
}



function main()
{
    # AKTU.
    update
    # INSTALL.
    sws_install_depending python-jinja2 python-pip libssl-dev python-dev libffi-dev gcc python-selinux software-properties-common
    # SET IP and INTER
    set_network_interfaces
    # PIP
    pip_iu pip pbr==2.0.0 docker==3.1.1 cryptography==1.9 Jinja2==2.10 gitdb==0.6.4 GitPython==1.0.1 six==1.10.0 oslo.config==5.2.0 oslo.utils==3.33.0 setuptools==21.0.0 netaddr==0.7.18 PyYAML==3.12 pycrypto==2.6
    # PIP ansible and kolla-ansible
    pip_iu ansible==2.4.3.0 kolla-ansible==4.0.3
    sudo cp -r /usr/local/share/kolla-ansible/etc_examples/kolla /etc/kolla
    globals_config_yml
    sudo kolla-ansible certificates
    sudo mkdir -p /etc/kolla/config/nova
    sudo cat > /etc/kolla/config/nova/nova-compute.conf << EOF
[libvirt]
virt_type = qemu
cpu_mode = none
EOF
    sudo kolla-genpwd
    sudo kolla-ansible -i /usr/local/share/kolla-ansible/ansible/inventory/all-in-one bootstrap-servers
    sudo kolla-ansible pull
    sudo kolla-ansible prechecks -i /usr/local/share/kolla-ansible/ansible/inventory/all-in-one
    sudo kolla-ansible deploy -i /usr/local/share/kolla-ansible/ansible/inventory/all-in-one
    sudo docker ps -a
    sudo kolla-ansible post-deploy
    sudo pip install python-openstackclient
    init_runonce
    sudo -s
    ###
    source /etc/kolla/admin-openrc.sh
    cd /usr/local/share/kolla-ansible/ && ./init-runonce
    sudo grep keystone_admin_password /etc/kolla/passwords.yml
    show_message OK "DONE. Your Openstack is ready!"
}

main