#!/bin/bash

arch=$(uname -srvmo)
pcpu=$(grep '^core id' /proc/cpuinfo | sort -u | wc -l)
vcpu=$(grep processor /proc/cpuinfo | wc -l)
ramt=$(free -m | grep Mem | awk '{print $2}')
ramu=$(free -m | grep Mem | awk '{print $3}')
ramp=$(free -m | grep Mem | awk '{printf("%d%%"), $3 / $2 * 100}')
diskt=$(df -m --total | grep total | awk '{print $2}')
disku=$(df -m --total | grep total | awk '{print $3}')
diskp=$(df -m --total | grep total | awk '{print $5}')
cpup=$(top -bn1 | awk '/^%Cpu/ {print (100 - $8) "%"}')
boot=$(who -b | awk '{print ($3 " @ " $4)}')
lvm=$(if lsblk | grep -q lvm; then echo yes; else echo no; fi)
tcp=$(ss -t | grep '^ESTAB' | wc -l)
users=$(who | wc -l)
ip=$(hostname -I)
mac=$(ip link | grep link/ether | awk '{print $2}')
sudo=$(grep COMMAND /var/log/sudo/sudo.log | wc -l)

wall "
	Architecture	: $arch
	PCPUs			: $pcpu
	VCPUs			: $vcpu
	Memory Usage	: $ramu / $ramt"mb" ($ramp)
	Disk Usage		: $disku / $diskt"mb" ($diskp)
	CPU Load		: $cpup
	Last Boot		: $boot
	LVM use			: $lvm
	TCP Connections	: $tcp established
	Users logged	: $users
	Network			: $ip ($mac)
	Sudo			: $sudo commands used
	"
