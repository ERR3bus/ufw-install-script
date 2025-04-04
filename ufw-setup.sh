
#!/bin/bash

# Colors
error="\033[1;31m"
info="\033[1;32m"
warning="\033[1;33m"
wipe="\033[0m"

# Label color
label="\e[4;32m"
wipe_label="\e[0m"

# check for sudo
if [ "$EUID" -ne 0 ]
	then echo -e "[ $error X $wipe ] $error Please run as root. Try run with sudo. $wipe"
	exit
fi

# info
echo ""
echo -e "$label STARTING UFW SETUP SCRIPT $wipe_label"

# detect distro
detect_distro () {
	if [ -f /etc/os-release ]; then
		. /etc/os-release
		DISTRO=$ID
	else
		DISTRO=$(uname -s)
	fi

	echo -e "[ $info INFO $wipe ] Detected Distribution: $info $DISTRO $wipe " 

	case "$DISTRO" in
		ubuntu|debian)
			INSTALL_CMD="apt-get install -y ufw"
			CHECK_CMD="apt list --installed | grep ufw"
			;;
		centos|rhel|fedora)
			INSTALL_CMD="dnf install -y ufw"
			CHECK_CMD="dnf list installed | grep ufw"
			;;
		opensuse|suse)
			INSTALL_CMD="zypper install -y ufw"
			CHECK_CMD="zypper search --installed-only ufw"
			;;
		arch)
			INSTALL_CMD="pacman -Sy ufw"
			CHECK_CMD="pacman -Q | grep ufw"
			;;
		void)
			INSTALL_CMD="xbps-install -Sy ufw"
			CHECK_CMD="xbps-query -l | grep ufw"
			;;
		*)
			echo -e "[ $warning WARNING $wipe ] $warning Unsupported Linux Distribution. $wipe"
			echo -e "[ $error X $wipe ] $error Exiting... $wipe"
			exit 1
			;;
	esac
}

# check if ufw is installed and install if not
check_and_install () {
	echo -e "[ $info INFO $wipe ] Installing UFW and its dependencies "
	if eval $CHECK_CMD &>/dev/null; then
		echo -e "[ $warning WARNING $wipe ] UFW is already installed."
	else
		echo -e "[ $warning WARNING $wipe ] UFW is not installed. Installing now..."
		eval $INSTALL_CMD
	fi
}

# enable ufw service 
detect_init_system_enable_UFW () {
	# detect innit system
	INIT_SYSTEM=$(ps --no-headers -o comm 1)

	case "$INIT_SYSTEM" in
		systemd)
			echo -e "[ $info INFO $wipe ] Detected Init System: $info $INIT_SYSTEM. $wipe"
			echo -e "[ $info INFO $wipe ] Starting service on boot."
			systemctl enable ufw
			systemctl start ufw
			echo ""
			echo -e $label STATUS OF SERVICE $wipe_label
			systemctl status ufw
			echo ""
			;;
		openrc)
			echo -e "[ $info INFO $wipe ] Detected Init System: $info $INIT_SYSTEM. $wipe"
			echo -e "[ $info INFO $wipe ] Starting service on boot."
			rc-update add ufw
			rc-service ufw start
			echo ""
			echo -e $label STATUS OF SERVICE $wipe_label
			rc-service ufw status
			echo ""
			;;
		runit)
			echo -e "[ $info INFO $wipe ] Detected Init System: $info $INIT_SYSTEM. $wipe"
			echo -e "[ $info INFO $wipe ] Starting service on boot."
			#ln -s /etc/sv/ufw /var/service/ufw
			#sv up ufw
			echo ""
			echo -e $label STATUS OF SERVICE $wipe_label
			sv status ufw
			echo ""
			;;
		*)
			echo -e "[ $warning WARNING $wipe ] $warning Unsupported Init System. $wipe"
			echo -e "[ $error X $wipe ] $error Exiting... $wipe"
			exit 1
			;;
	esac
}

#	HERE YOU CAN MODIFY YOUR UFW RULES	#
#
# ufw rules -> modify this function as you see fit

ufw_rules () {
	echo -e "[ $warning WARNING $wipe ] Applying UFW rules from ufw_rules function." 
	# rules
#	ufw default deny incoming
#	ufw default allow outgoing

	# enable ufw firewall
	echo ""
	ufw enable
}

# MAIN / main logic
detect_distro
check_and_install
detect_init_system_enable_UFW
ufw_rules

# done
echo ""
echo -e $label STATUS OF UFW $wipe_label
ufw status
