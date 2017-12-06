# Zadanie 6. Lista regul firewall -----------------------------------------------------------------------------------------------------------------------------------------------------------
# firewall ( iptables)

#Print all rules in the selected chain.  If no chain is selected,
#              all chains are printed like iptables-save. Like every other ipt‐
#              ables command, it applies to the specified table (filter is  the
#              default).

#The -n option help to print IP addresses and port numbers in numeric format.
#To output all of the active iptables rules in a table, run the iptables command with the -L option:
sudo iptables -L -n | tee -a Zadanie.txt
sudo iptables -L | tee -a Zadanie.txt
sudo iptables -L INPUT | tee -a Zadanie.txt
iptables -t nat -L | tee -a Zadanie.txt
iptables -t nat -L --line-numbers -n | tee -a Zadanie.txt
iptables -t filter -L | tee -a Zadanie.txt
iptables -t raw -L | tee -a Zadanie.txt
iptables -t security -L | tee -a Zadanie.txt
iptables -t mangle -L | tee -a Zadanie.txt
iptables -t nat -L | tee -a Zadanie.txt

#To list out all of the active iptables rules by specification, run the iptables command with the -S option:
sudo iptables -S | tee -a Zadanie.txt

#If you want to limit the output to a specific chain (INPUT, OUTPUT, TCP, etc.), you can specify the chain name directly after the -S option. For example, to show all of the rule specifications in the TCP chain, you would run this command:
sudo iptables -S TCP | tee -a Zadanie.txt

ip6tables -L -n -v | tee -a Zadanie.txt
ip6tables -L -n -v -t nat --line-numbers | tee -a Zadanie.txt

#The –line-numbers option adds line numbers to the beginning of each rule, corresponding to that rule’s position in the chain. The -v option makes the list command show the interface name, the rule options (if any), and the TOS masks. The packet and byte counters are also listed, with the suffix K, M or G for 1000, 1,000,000 and 1,000,000,000 multipliers respectively (but see the -x flag to change this).
iptables -L -v -n --line-numbers | tee -a Zadanie.txt

#When listing iptables rules, it is also possible to show the number of packets, and the aggregate size of the packets in bytes, that matched each particular rule. This is often useful when trying to get a rough idea of which rules are matching against packets. To do so, simply use the -L and -v option together.
#For example, let's look at the INPUT chain again, with the -v option:
sudo iptables -L INPUT -v | tee -a Zadanie.txt

#If you want to clear, or zero, the packet and byte counters for your rules, use the -Z option. They also reset if a reboot occurs. This is useful if you want to see if your server is receiving new traffic that matches your existing rules.
#To clear the counters for all chains and rules, use the -Z option by itself:
sudo iptables -Z | tee -a Zadanie.txt

#To clear the counters for all rules in a specific chain, use the -Z option and specify the chain. For example, to clear the INPUT chain counters run this command:
sudo iptables -Z INPUT | tee -a Zadanie.txt

#If you want to clear the counters for a specific rule, specify the chain name and the rule number. For example, to zero the counters for the 1st rule in the INPUT chain, run this:
sudo iptables -Z INPUT 1 | tee -a Zadanie.txt

# Więcej info https://help.ubuntu.com/community/IptablesHowTo