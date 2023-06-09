#Born2BRoot

#partition table

	primary:

		/boot

	encrypted logical volumes:

		swap
		/
		/home
		/tmp
		/srv
		/var
		/var-log

#firstboot

	lsblk
	cat /etc/os-release

	su root
	apt update
	apt upgrade
	apt install sudo

#add user to sudo group
	sudo usermod -aG sudo <username>
	sudo whoami

#edit sudoers.tmp
	sudo visudo
		username ALL=(ALL:ALL) ALL

		Defaults	passwd_tries=3
		Defaults	badpass_message="Wrong password. Try again!"
		Defaults	logfile="/var/log/sudo/sudo.log"
		Defaults	log_input
		Defaults	log_output
		Defaults	requiretty

#firewall
	apt install ufw
	ufw enable
	ufw status verbose
	ufw allow <port>
	ufw deny <port>
	ufw delete allow <port>
	ufw delete deny <port>
	ufw status numbered
	ufw delete <port index number>

#openSSH
	apt install openssh-server
	sudo systemctl status ssh
	nano /etc/ssh/sshd_config
		Port 4242
	systemctl restart ssh
	VM >> Settings >> Network >> Adapter 1 >> Advanced >> Port Forwarding.
		Port 4242
	ssh <username>@localhost/VMip -p 4242

#pwpolicy
	Edit /etc/login.defs
		PASS_MAX_DAYS 30
		PASS_MIN_DAYS 2
		PASS_WARN_AGE 7
	changes aren't automatically applied to existing users
		sudo chage -l <username/root>
		sudo chage -M 30 <username/root>
		sudo chage -m 2 <username/root>
		sudo chage -W 7 <username/root>
	method 1
		sudo apt install libpam-pwquality
			/etc/security/pwquality.conf
			# Number of characters in the new password that must not be present in the old one.
				difok = 7
			# The minimum acceptable size for the new password.
			# (plus one if credits are not disabled which is the default)
				minlen = 10
			# The maximum credit for having digits in the new password.
			# If less than 0 it is the minimun number of digits in the new password.
				dcredit = -1
			# The maximum credit for having uppercase characters in the new password.
			# If less than 0 it is the minimun number of uppercase characters in the new password.
				ucredit = -1
			# The maximum credit for having lowercase characters in the new password.
			# If less than 0 it is the minimun number of uppercase characters in the new password.
				lcredit = -1
			# The maximum number of allowed consecutive same characters in the new password.
			# The check is disabled if the value is 0.
				maxrepeat = 3
			# Whether to check it it contains the user name in some form.
			# The check is disabled if the value is 0.
				usercheck = 1 / reject_username
			# Prompt user at most N times before returning with error. The default is 1.
				retry = 3
			# Enforces pwquality checks on the root user password.
			# Enabled if the option is present.
				enforce_for_root
	method 2
		sudo apt-get install libpam-pwquality
			sudo vim /etc/pam.d/common-password
				password  requisite     pam_pwquality.so  retry=3 minlen=10 ucredit=-1 dcredit=-1 lcredit =-1 maxrepeat=3 reject_username difok=7 enforce_for_root

#hostname/users/groups
	hostnamectl set-hostname <new_hostname>
	hostnamectl status
	useradd
		#creates a new user.
	usermod
		#changes the user’s parameters: -l for the username, -c for the full name, -g for groups by group ID.
	userdel -r
		#deletes a user and all associated files.
	id -u
		#displays user ID.
	users
		#shows a list of all currently logged in users.
	cat /etc/passwd | cut -d ":" -f 1
		#displays a list of all users on the machine.
	cat /etc/passwd | awk -F '{print $1}'
		#displays a list of all users on the machine.

	groupadd
		#creates a new group.
	gpasswd -a
		#adds a user to a group.
	gpasswd -d
		#removes a user from a group.
	groupdel
		#deletes a group.
	groups
		#displays the groups of a user.
	id -g
		#shows a user’s main group ID.
	getent group
		#displays a list of all users in a group.

#broadcast .sh
	cd /usr/local/bin/
	systemctl enable cron
	sudo crontab -u root -e
		*/10 * * * * bash /usr/local/bin/sleep.sh && bash /usr/local/bin/monitoring.sh
	sudo visudo
		your_username ALL=(root) NOPASSWD: /usr/local/bin/monitoring.sh

#script notes

	Architecture
		arch=$(uname -srvmo)
	CPUs
		pcpu=$(lscpu | grep 'Core(s)' | awk '{print $4}')
		vcpu=$(lscpu | grep 'Thread(s)' | awk '{print $4}')
		tcpu=$(($pcpu * $vcpu))
		cpup=$(top -bn1 | grep '%Cpu(s)' | awk '{printf("%d%%", $2 + $4)}')
	Memory
		ramt=$(free -m | grep Mem | awk '{print $2}')
		ramu=$(free -m | grep Mem | awk '{print $3}')
		ramp=$(free -m | grep Mem | awk '{printf("%d%%"), $3 / $2 * 100}')
	Disk
		diskt=$(df -m --total | grep total | awk '{print $2}')
		disku=$(df -m --total | grep total | awk '{print $3}')
		diskp=$(df -m --total | grep total | awk '{print $5}')
	Last Reboot
		rboot=$(last | grep 'reboot' | grep 'still running' -m 1 | awk '{print $5" "$6" "$7" @ "$8}')
	LVM
		lvm=$(if lsblk | grep -q lvm; then echo yes; else echo no; fi)
	Logged Users
		users=$(users | wc -w)
	Network
		tcp=$(ss | grep 'tcp' | wc -l)
		ip=$(hostname -I)
		mac=$(ip link | grep link/ether | awk '{print $2}')
	Sudo Log
		sudo=$(grep 'COMMAND=' /var/log/sudo/sudo.log | wc -l)

#display
	VBoxVGA

#signature
	path
		Windows: %HOMEDRIVE%%HOMEPATH%\VirtualBox VMs\
		Linux: ~/VirtualBox VMs/
		MacM1: ~/Library/Containers/com.utmapp.UTM/Data/Documents/
		MacOS: ~/VirtualBox VMs/
	call
		Windows: certUtil -hashfile yourmachine.vdi sha1
		Linux: sha1sum yourmachine.vdi
		For Mac M1: shasum yourmachine.utm/Images/disk-0.qcow2
		MacOS: shasum yourmachine.vdi
