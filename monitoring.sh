#!/bin/bash

arch=$(uname -srvmo)
pcpu=$(lscpu | grep 'Core(s)' | awk '{print $4}')
vcpu=$(lscpu | grep 'Thread(s)' | awk '{print $4}')
tcpu=$(($pcpu * $vcpu))
ramt=$(free -m | grep Mem | awk '{print $2}')
ramu=$(free -m | grep Mem | awk '{print $3}')
ramp=$(free -m | grep Mem | awk '{printf("%d%%"), $3 / $2 * 100}')
diskt=$(df -m --total | grep total | awk '{print $2}')
disku=$(df -m --total | grep total | awk '{print $3}')
diskp=$(df -m --total | grep total | awk '{print $5}')
cpup=$(top -bn1| grep '%Cpu(s)' | awk '{printf("%d%%", $2 + $4)}')
rboot=$(last | grep 'still running' -m 1 | awk '{print $5" "$6" "$7" @ "$8}')
lvm=$(if lsblk | grep -q lvm; then echo yes; else echo no; fi)
tcp=$(ss | grep 'tcp' | wc -l)
users=$(users | wc -w)
ip=$(hostname -I)
mac=$(ip link | grep link/ether | awk '{print $2}')
sudo=$(grep 'COMMAND=' /var/log/sudo/sudo.log | wc -l)

wall "
	Architecture	: $arch
	PCPUs			: $pcpu
	VCPUs			: $tcpu
	Memory Usage	: ($ramp) $ramu"mb"/$ramt"mb"
	Disk Usage		: ($diskp) $disku"mb"/$diskt"mb"
	CPU Load		: $cpup
	Last Reboot		: $rboot
	LVM use			: $lvm
	TCP Connections	: $tcp established
	Users logged	: $users
	Network			: $ip ($mac)
	Sudo			: $sudo commands used
	"
