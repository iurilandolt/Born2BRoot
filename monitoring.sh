#!/bin/bash

arch=$(uname -srvmo)

pcpu=$(grep 'physical id' /proc/cpuinfo | uniq | wc -l)

vcpu=$(grep processor /proc/cpuinfo | uniq | wc -l)

rtotal=$(free -h | grep Mem | awk '{print $2}')

rused=$(free -h | grep Mem | awk '{print $3}')

rperc=$(free -k | grep Mem | awk '{printf("%.2f%%"), $3 / $2 * 100}')

dtotal=$(df -h --total | grep total | awk '{print $2}')

dtotal=$(df -h --total | grep total | awk '{print $3}')

dperc=$(df -k --total | grep total | awk '{print $5}')

cpuload=$(top -bn1 | grep '^%Cpu' | xargs | awk '{printf("%.1f%%"), $2 + $4}')

lboot=$(who -b | awk '{print($3 " " $4)}')

lvm=$(if [ $(lsblk | grep lvm | wc -l) -eq 0 ]; then echo no; else echo yes; fi)

tcp=$(ss -t | grep '^ESTAB' | wc -l)

luser=$(who | wc -l)

ip=$(hostname -I | awk '{print $1}')

mac=$(ip link show | grep link/ether | awk '{print $2}')

sudo=$(grep COMMAND /var/log/sudo/sudo.log | wc -l)


wall "
       ------------------------------------------------
       architecture    : $arch
       Physical CPUs   : $pcpu
       Virtual CPUs    : $vcpu
       Memory Usage    : $rused/$rtotal ($rperc)
       Disk Usage      : $dtotal/$dtotal ($dperc)
       CPU Load        : $cpuload
       Last Boot       : $lboot
       LVM use         : $lvm
       TCP Connections : $tcp established
       Users logged    : $luser
       Network         : $ip ($mac)
       Sudo            : $sudo commands used
       ------------------------------------------------"
#wall = wrote all - send mensage to all users
