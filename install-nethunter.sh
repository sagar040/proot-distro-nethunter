#!/data/data/com.termux/files/usr/bin/bash

# Install Kali Nethunter (official version) on proot-distro.

# This script streamlines the integration of Kali NetHunter with the proot-distro tool. It simplifies the setup and management of NetHunter distributions within a proot-based environment.

# Providing security professionals with an easy-to-use setup and management solution for NetHunter distributions.

# Key Features:
# - Automated integration of Kali NetHunter into proot-distro, eliminating manual configuration steps.
# - Calculation of the SHA256 checksum of the NetHunter rootfs to ensure data integrity during installation.
# - Facilitation of the installation process, providing a straightforward setup experience.

# Benefits:
# - Easy setup and management of Kali NetHunter distributions within a proot-based environment.
# - Swift installation process, reducing manual effort and saving time.

# Author: Sagar Biswas
# GitHub Repository: https://github.com/sagar040/proot-distro-nethunter

set -e

SCRIPT_VERSION="1.4"

banner() {
    clear
    local B='\e[38;1m'
    local C0='\e[38;5;236m'
    local C1='\e[38;5;18m'
    local C2='\e[38;5;19m'
    local C3='\e[38;5;20m'
    local C4='\e[38;5;21m'
    local C5='\e[38;5;57m'
    local C6='\e[38;5;56m'
    local C7='\e[38;5;93m'
    local C8='\e[38;5;92m'
    local C9='\e[38;5;91m'
    local C10='\e[38;5;128m'
    local C11='\e[38;5;127m'
    local R='\033[0m'
    local S=$(printf '%*s' 12 '')
    echo -e "$B$S$C1......., ,,.."
    echo -e "$S        ...cnx,"
    echo -e "$S$C2 $C5..$R$C2.'''$B$C2 ...:lb;."
    echo -e "$S$C3        $R$C3,;;$B$C3...x,"
    echo -e "$S   $R$C6..$R$C5''$B$C4.       0xc, .."
    echo -e "$S  $R$C7..$B$C4          ,0c,;ckc',"
    echo -e "$S $R$C5'$B$C4          0o        :nn"
    echo -e "$S           On           .:x."
    echo -e "$S           xX"
    echo -e "$S$C5            x0"
    echo -e "$S$C6             ,d$R"$C7"d$B:,."
    echo -e "$S$C9                  .:"$R$C9"c$C9,."
    echo -e "$S$C9                    d,$C9 ''"
    echo -e "$S$C10                      b $C10 '.$C3"
    echo -e "$S$C11                       c"
    echo -e "$S                       '\n"
}

# rootfs path
nh_rootfs="$PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack-linux"

# info
info() {
    banner
    echo -e "\e[38;5;242;1m  -------------- Kali Nethunter Installer --------------\033[0m\n"
    echo -e "\e[38;5;253mInstall Kali Nethunter (official version) on proot-distro. This is a Bash script that automates the installation of Kali NetHunter with the proot-distro tool.\033[0m\n"
    echo -e "\e[38;5;45mVersion:\033[0m \033[1;33m$SCRIPT_VERSION\033[0m\n"
    echo -e "\e[38;5;45mUsage:\033[0m $0 --install\n"
    echo -e "\e[38;5;45mGithub Repo:\033[0m \e[38;5;240mhttps://github.com/sagar040/proot-distro-nethunter\033[0m\n"
    echo -e ""
    exit 0
}

# Check device architecture and set system architecture
get_architecture() {
    supported_arch=("arm64-v8a" "armeabi" "armeabi-v7a")
    device_arch=$(getprop ro.product.cpu.abi)

    printf "\033[33;1minstaller:\033[0m Checking device architecture...\n"

    if [[ " ${supported_arch[@]} " =~ " $device_arch " ]]; then
        case $device_arch in
            "arm64-v8a")
                SYS_ARCH="arm64"
                ;;
            "armeabi" | "armeabi-v7a")
                SYS_ARCH="armhf"
                ;;
        esac
        printf "\033[33;1minstaller:\033[0m Device architecture: $SYS_ARCH\n"
    else
        echo -e "E: \033[31mUnsupported Architecture\033[0m"
        exit 1
    fi
}

# Install required packages
install_packages() {
    printf "\n\033[33;1minstaller:\033[0m Installing required packages...\n"
    apt update && apt upgrade -y
    apt install -y proot-distro curl
}

# Get Nethunter installation type
select_installation_type() {
    echo -e "\n\033[33mKali Nethunter ($SYS_ARCH)\033[0m\n"
    echo -e "NO     installation type          required disk space\n"
    echo -e "1.     nethunter                       6 GB"
    echo -e "2.     nethunter lite                  4 GB"
    echo -e "3.     nethunter terminal (no GUI)   2.5 GB\n"

    read -p "Select installation type (default: 1): " installation_type

    case "$installation_type" in
        1) img="default";;
        2) img="lite";;
        3) img="ngui";;
        *) img="default";;
    esac
}

# Retrieve SHA256 checksum for the selected Nethunter image
get_sha256_checksum() {
    base_url="https://kali.download/nethunter-images/current/rootfs"
    sha256_url="$base_url/SHA256SUMS"
    rootfs="kalifs-$SYS_ARCH-minimal.tar.xz"

    printf "\n\033[33;1minstaller:\033[0m Retrieving SHA256 checksum...\n"
    SHA256=$(curl -s "$sha256_url" | grep "$rootfs" | awk '{print $1}')

    if [[ -z "$SHA256" ]]; then
        echo -e "E: \033[31mFailed to retrieve SHA256 checksum. Exiting.\033[0m"
        exit 1
    fi

    printf "\033[34mSHA256SUM:\033[0m $SHA256\n"
}

# Generate and save the proot-distro configuration file
generate_config_file() {
    distro_file="# Kali nethunter $SYS_ARCH
DISTRO_NAME=\"kali Nethunter ($SYS_ARCH)\"
DISTRO_COMMENT=\"Kali nethunter $SYS_ARCH (official version)\"
TARBALL_URL['aarch64']=\"$base_url/$rootfs\"
TARBALL_SHA256['aarch64']=\"$SHA256\""

    printf "$distro_file" > "$PREFIX/etc/proot-distro/BackTrack-linux.sh"
}

# Packages
pkgs_nh_default(){
    proot-distro login BackTrack-linux -- apt install -y xfce4 xfce4-terminal terminator tigervnc-standalone-server xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr nmap ncat python3 python3-pip socat john hydra  gobuster dirb dirbuster wordlists vim binwalk cewl wpscan ffuf wfuzz sqlmap sqlite3 nikto villain autopsy metasploit-framework burpsuite wireshark

}

pkgs_nh_lite(){
    proot-distro login BackTrack-linux -- apt install -y xfce4 xfce4-terminal terminator tigervnc-standalone-server xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr nmap ncat socat john hydra  gobuster dirb dirbuster wordlists vim binwalk cewl wpscan ffuf wfuzz sqlmap sqlite3 nikto villain autopsy
}

pkgs_nh_terminal(){
    proot-distro login BackTrack-linux -- apt install -y nmap ncat python3 python3-pip socat john hydra  gobuster dirb dirbuster wordlists vim binwalk cewl wpscan ffuf wfuzz sqlmap sqlite3 nikto villain autopsy termshark
}

# Setup Nethunter
setup_nethunter(){
    # hide Kali developers message
    touch $nh_rootfs/root/.hushlogin
    touch $nh_rootfs/home/kali/.hushlogin
    
    proot-distro login BackTrack-linux -- bash -c 'apt update
    apt upgrade -y
    apt autoremove -y
    apt install apt-utils command-not-found
    echo "kali    ALL=(ALL:ALL) ALL" > /etc/sudoers.d/kali'
}

# Set up Nethunter GUI
gui_setup() {
    echo -e "\033[33;1minstaller:\033[0m Setting up Nethunter GUI..."
    # Add xstartup file
    cp "./VNC/xstartup" "$nh_rootfs/root/.vnc/"
    # kgui executable
    cp "./VNC/kgui" "$nh_rootfs/usr/bin/"
    # Fix ㉿ symbol encoding issue on terminal
    cp "./fonts/NishikiTeki-font.ttf" "$nh_rootfs/usr/share/fonts/"

    proot-distro login BackTrack-linux -- bash -c 'chmod +x ~/.vnc/xstartup
    chmod +x /usr/bin/kgui'
}


if [[ $1 == "--install" ]]; then
    # Main script
    get_architecture
    install_packages
    select_installation_type
    get_sha256_checksum
    generate_config_file
    
    printf "\n\033[33;1minstaller:\033[0m Distribution added as BackTrack-linux\n"
    
    # Install Nethunter
    proot-distro install BackTrack-linux
    
    # Update and setup
    printf "\n\033[33;1minstaller:\033[0m Setting up nethunter...\n"
    setup_nethunter
    
    # installation function based on the installation_type
    if [ "$installation_type" = "default" ]; then
        pkgs_nh_default
        gui_setup
    elif [ "$installation_type" = "lite" ]; then
        pkgs_nh_lite
        gui_setup
    elif [ "$installation_type" = "ngui" ]; then
        pkgs_nh_terminal
    fi
    
    echo -e "\n\033[33;1minstaller:\033[0m successfully installed nethunter\n"
    
    # Shortcut
    echo '[ -n "$1" ] && proot-distro login BackTrack-linux --user "$1" || proot-distro login BackTrack-linux' > $PREFIX/bin/nethunter
    chmod +x $PREFIX/bin/nethunter
    
    # Print instructions
    echo -e "\nLogin: \033[32mnethunter [user]\033[0m (default=root)"
    echo -e "\n\033[33;1minstaller:\033[0m For GUI access, run \033[32mkgui\033[0m command. (after login into nethunter)"
else
    info
fi
