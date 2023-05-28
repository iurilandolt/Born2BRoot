#!/bin/bash

arch=$(uname -srvmo)

pcpu=$(grep '^core id' /proc/cpuinfo | sort -u | wc -l)

vcpu=$(grep processor /proc/cpuinfo | wc -l)

rtotal=$(free -h | grep Mem | awk '{print $2}')

rused=$(free -h | grep Mem | awk '{print $3}')

rperc=$(free -m | grep Mem | awk '{printf("%.2f%%"), $3 / $2 * 100}')

dtotal=$(df -h --total | grep total | awk '{print $2}')

dused=$(df -h --total | grep total | awk '{print $3}')

dperc=$(df -k --total | grep total | awk '{print $5}')

cpuload=$(top -bn1 | awk '/^%Cpu/ {print (100 - $8) "%"}')

lboot=$(who -b | awk '{print ($3 " @ " $4)}')

lvm=$(if lsblk | grep -q lvm; then echo yes; else echo no; fi)

tcp=$(ss -t | grep '^ESTAB' | wc -l)

luser=$(who | wc -l)

ip=$(hostname -I)

mac=$(ip a | grep link/ether | awk '{print $2}')

sudo=$(grep COMMAND /var/log/sudo/sudo.log | wc -l)


wall "
       ------------------------------------------------
       architecture    : $arch
       Physical CPUs   : $pcpu
       Virtual CPUs    : $vcpu
       Memory Usage    : $rused/$rtotal($rperc)
       Disk Usage      : $dused/$dtotal($dperc)
       CPU Load        : $cpuload
       Last Boot       : $lboot
       LVM use         : $lvm
       TCP Connections : $tcp established
       Users logged    : $luser
       Network         : $ip ($mac)
       Sudo            : $sudo commands used
       ------------------------------------------------"
#wall = wrote all - send mensage to all users
