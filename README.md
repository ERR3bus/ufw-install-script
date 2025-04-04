# ufw-install-script
Simple automation bash script for installing and enabling ufw on linux distro (you can check supported distros in README.md).
Created to help replicate ufw settings across new linux instalations.

### Supported distros are: 
- [X] Debian
- [X] Ubuntu
- [X] Open SUSE
- [X] Arch Linux
- [X] Void Linux
- [X] Red Hat based distributions (Fedora Linux, CentOS, Rocky Linux)

## Requirements
### It must be run as superuser (sudo) or as root.
Other requirements:
> ps,
> grep
## Configuration
### You can configure preset ufw rules inside ufw_rules function.

---

## Usage
### Clone repository
`git clone https://github.com/ERR3bus/ufw-install-script.git`

### Enter scripts directory
`cd ufw-install-script`

### Make script executable
`chmod +x ufw-setup.sh`

### Run script
`sudo ./ufw-setup.sh` 
or run as root 
`./ufw-setup.sh`

# Warning !!!
### 1. Script will try to install ufw and its packages if they are not present, and will try to enable it as service inside your init system.
### 2. Example rules WILL lock you out from ssh session !!! (for servers)


## Contribution And Issues
Please open an issue or submit pull request with any suggestions of improvment.  (^_^)

## License
This project is under MIT License. See LICENSE file for details.
