#!/bin/bash

ARCH=$(uname -srvmo)
#print system info
#	-s, --kernel-name
#	-r, --kernel-release
#	-v, --kernel-version
#	-m, --machine
#	-o, --operating-system
PCPU=$(grep 'physical id' /proc/cpuinfo | uniq | wc -l)
#grep assigns number of CPUs
#uniq filters duplicate lines of 'physical id'
#wc -l counts number of lines (= number of cpus found in /proc/cpuinfo)
VCPU=$(grep processor /proc/cpuinfo | uniq | wc -l)
#assigns number of VCPUs
RAM_TOTAL=$(free -h | grep Mem | awk '{print $2}')
#free -h - format to human readable (megabytes/gigabytes)
#grep filter output to 'Mem' only
#awk '{print $2}' filter second field of previous command output
RAM_USED=$(free -h | grep Mem | awk '{print $3}')
RAM_PERC=$(free -k | grep Mem | awk '{printf("%.2f%%"), $3 / $2 * 100}')
#free -k - format to kilobytes
#awk '{printf("%.2f%%"), $3 / $2 * 100}' - calculate % of used ram
DISK_TOTAL=$(df -h --total | grep total | awk '{print $2}')
#df displays information about disk space usage
#-h - format to human readable
#--total aggregates disk space across all file systems
#grep total filters output to value of all file systems
DISK_USED=$(df -h --total | grep total | awk '{print $3}')
DISK_PERC=$(df -k --total | grep total | awk '{print $5}')
CPU_LOAD=$(top -bn1 | grep '^%Cpu' | xargs | awk '{printf("%.1f%%"), $2 + $4}')
#top -bn1 - monitor system process and resource usage
#grep '^%Cpu filter out lines that start with '^%Cpu'
#xargs pass arguments from previous command to next command
#awk extract fields 2 and 4
LAST_BOOT=$(who -b | awk '{print($3 " " $4)}')
#who -b - displays last user who booted the system
LVM=$(if [ $(lsblk | grep lvm | wc -l) -eq 0 ]; then echo no; else echo yes; fi)
#lsblk list block devices on system
#grep lvm and if else statement check if there is any line containing 'lvm'
#in the output of lsblk and displays yes or no accordingly
TCP=$(grep TCP /proc/net/sockstat | awk '{print $3}')
USER_LOG=$(who | wc -l)
IP_ADDR=$(hostname -I | awk '{print $1}')
#retrieve ip adress, print first parameter
MAC_ADDR=$(ip link show | grep link/ether | awk '{print $2}')
#show network interfaces in system
#filter lines with 'link/ether'
SUDO_LOG=$(grep COMMAND /var/log/sudo/sudo.log | wc -l)
#filters use of string 'COMMAND' inside sudo.log
#wc -l gives us line count of previous search

wall "
       ------------------------------------------------
       Architecture    : $ARCH
       Physical CPUs   : $PCPU
       Virtual CPUs    : $VCPU
       Memory Usage    : $RAM_USED/$RAM_TOTAL ($RAM_PERC)
       Disk Usage      : $DISK_USED/$DISK_TOTAL ($DISK_PERC)
       CPU Load        : $CPU_LOAD
       Last Boot       : $LAST_BOOT
       LVM use         : $LVM
       TCP Connections : $TCP established
       Users logged    : $USER_LOG
       Network         : $IP_ADDR ($MAC_ADDR)
       Sudo            : $SUDO_LOG commands used
       ------------------------------------------------"
#wall = wrote all - send mensage to all users
