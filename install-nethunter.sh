#!/data/data/com.termux/files/usr/bin/bash

# Install Kali NetHunter (official version) on proot-distro.

# The proot-distro-nethunter is a powerful Bash script designed to effortlessly integrate Kali NetHunter into proot-distro.
# This enables users to deploy multiple NetHunter instances with customized toolsets, akin to managing multiple containers in Docker.

# Whether you're a cybersecurity professional or an enthusiast, this installer streamlines the setup process, saving time and effort.

## Features

# 1. Automated Integration : Seamlessly integrates Kali NetHunter into proot-distro, eliminating manual configurations.
# 2. Customization : Install multiple NetHunters with tailored toolsets, optimized for various tasks.
# 3. Enhanced UX : Automatically sets up VNC server for XFCE desktop, enhancing graphical user experience.
# 4. Efficiency : Swift installation process reduces manual intervention, making deployment hassle-free.

# Author: Sagar Biswas
# GitHub Repository: https://github.com/sagar040/proot-distro-nethunter
# License : https://raw.githubusercontent.com/sagar040/proot-distro-nethunter/main/LICENSE
# proot-distro-nethunter  Copyright (C) 2024  Sagar Biswas




SCRIPT_VERSION="1.7"
current_datetime=$(date +"%d.%m.%Y-%H:%M")
device_avilable_storage=$(df -h | grep '/storage/emulated' | awk '{print $4}' | tr -d '[:alpha:]')


device_total_ram=$(free -b | awk 'NR==2 {print $2}')
device_total_ram_gb=$(echo "scale=2; $device_total_ram / (1024 * 1024 * 1024)" | bc)

print_error() {
    local error_val=$1
    echo -e "\033[31;1mError:\033[0m $error_val\n"
}

print_task_V1_7() {
    local task=$1
    local arrows="\033[38;5;11;1m>\033[38;5;226;1m>\033[38;5;227;1m>\033[38;5;228;1m>\033[38;5;229;1m>\033[38;5;230;1m>\033[38;5;231;1m>\033[0m"
    echo -e "$arrows \033[38;5;39m$task\033[0m $arrows"
}

print_done () {
    local msg=$1
    echo -e "[\033[32;1m\u2714\ufe0e\033[0m] $msg\n"
}


###################################################################
#                       NEW BANNER ANIMATION                      #
###################################################################


clear_console() {
    printf "\033c"
}
banner_lines=(
""
"      ............                          "
"              ....::::.                     "
"  ..........     ..:---                     "
"           ..:::::.....=       ' .          "
"      .::::.           +%**++=-:...         "
"    ..               =#-.    .:=+*+-.       "
"                    =#            .++:      "
"                    ==              .:-.    "
"                    :+:                     "
"                     :+=:                   "
"                       .:+:-+-====-::.      "
"                                  .:--:::   "
"                                     .=. :. "
"                                       :  . "
"                                        :   " 
)

animate_banner() {
    normal_color='\e[38;5;255;1m'
    bright_blue='\e[38;5;33;1m'
    bright_white='\e[38;5;231;1m'
    reset='\e[0m'

    clear
    tput civis
    
    for line in "${banner_lines[@]}"; do
        echo -e "${normal_color}${line}${reset}"
    done
    
    sleep 1.5
    
    for ((i=${#banner_lines[@]}-1; i>=0; i--)); do
        
        clear
        for ((j=0; j<${#banner_lines[@]}; j++)); do
            if [ $i -eq $j ]; then
                if [ $i -eq 0 ]; then
                    echo -e "${bright_white}${banner_lines[$j]}${reset}"
                else
                    echo -e "${bright_blue}${banner_lines[$j]}${reset}"
                fi
            else
                echo -e "${normal_color}${banner_lines[$j]}${reset}"
            fi
        done
        sleep 0.1
    done
}

# Banner for version 1.7
print_banner_with_color() {
    echo -e "CiAgICAgIBtbMzg7NTsxNjZtLi4uG1szODs1OzIwOG0uLi4uLhtbMzg7NTsyMDltLi4uLiAgICAg
ICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgG1szODs1OzIwOG0uLhtbMzg7NTsy
MTBtLi46OjobWzM4OzU7MjE3bTouICAgICAgICAgICAgICAgICAgICAgCiAgG1szODs1OzE2Nm0u
Li4uLhtbMzg7NTsyMDhtLi4uLi4gICAgIBtbMzg7NTsyMTBtLi46G1szODs1OzIxN20tLS0gICAg
ICAgICAgICAgICAgICAgICAKICAgICAgICAgICAbWzM4OzU7MjA4bS4uOjobWzM4OzU7MjA5bTo6
Oi4uLhtbMzg7NTsyMTBtLi49ICAgICAgIBtbMzg7NTswMzNtJyAuICAgICAgICAgIAogICAgICAb
WzM4OzU7MTY2bS46Ojo6LiAgICAgICAgICAgG1szODs1OzE5N20rJSoqKys9LTouLi4gICAgICAg
ICAKICAgIBtbMzg7NTsxNjZtLi4gICAgICAgICAgICAgICAbWzM4OzU7MjAzbT0jG1szODs1OzE2
Mm0tLiAgICAuOj0rKistG1szODs1OzAzM20uICAgICAgIAogICAgICAgICAgICAgICAgICAgIBtb
Mzg7NTsxNjJtPSMgICAgICAgICAgICAuKys6ICAgICAgCiAgICAgICAgICAgICAgICAgICAgPRtb
Mzg7NTsxNjNtPSAgICAgICAgICAgICAgG1szODs1OzA5MW0uG1szODs1OzA5Mm06LRtbMzg7NTsw
MzNtLiAgICAKICAgICAgICAgICAgICAgICAgICAbWzM4OzU7MTYzbTorOiAgICAgICAgICAgICAg
ICAgICAgIAogICAgICAgICAgICAgICAgICAgICA6G1szODs1OzEyN20rPTogICAgICAgICAgICAg
ICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgLjorG1szODs1OzA5MW06LSstG1szODs1OzA5
Mm09PT09LRtbMzg7NTswNjJtOjouICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAuOi0tOhtbMzg7NTswMzNtOjogICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIC49LiA6LiAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgOiAg
LiAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDogICAKICAgIAo=" | base64 -d

sa1=$(printf '%*s' 15 '')
sa2=$(printf '%*s' 5 '')
echo -e "$sa1\e[38;5;231;1mPRoo\e[38;5;253;1mt D\e[38;5;251;1mis\e[38;5;248;1mtro \e[38;5;196;1mNet\e[38;5;160;1mhun\e[38;5;124;1mter\e[0m\n"
}

info() {
    
    echo -e "\e[38;5;250mInstall Kali Nethunter (official version) on proot-distro. you can create multiple Nethunters from the same image with custom tools.\033[0m\n"
    
    echo -e "\e[38;5;155;1mVersion: $SCRIPT_VERSION\033[0m"
    echo -e "\e[38;5;45mKali Rolling release :\033[0m 2024.1"
    echo -e "\e[38;5;45mGithub Repo:\033[0m \e[38;5;253mhttps://github.com/sagar040/proot-distro-nethunter\033[0m"
    echo ""
    echo -e "\e[38;5;45mUsage:\033[0m $0 --install"
    echo -e ""
}

# Run the animations
animate_banner
clear_console
print_banner_with_color
tput cnorm

###################################################################
#                           MAIN PROGRAMS                         #
###################################################################

# List of valid IDs
valid_ids=(
    "KBDEXKMT10"
    "KBDEXKMTD"
    "KBDEXKMTL"
    "KBDEXKMTE"
    "KBCTDEX"
    "KBCIGDEX"
    "KBCWGDEX"
    "KBCCSGDEX"
    "KBCPGDEX"
    "KBCFOGDEX"
    "KBCFUGDEX"
    "KBCREGDEX"
    "KBCSSGDEX"
    "KBCEGDEX"
)


get_build_ID() {
    # Prompt user for ID
    printf "[\033[32;1m*\033[0m] Get build ID from here : \033[38;5;252mhttps://github.com/sagar040/proot-distro-nethunter/blob/main/README.md#list-of-kali-nethunter-builds"
    echo -e "\033[0m\n"
    printf "[\033[34;1m?\033[0m] Enter the build ID : \033[38;5;222m"; read BUILD_ID
    printf "\033[0m"

    # Check if the entered ID is valid
    valid=false
    for id in "${valid_ids[@]}"; do
        if [ "$BUILD_ID" = "$id" ]; then
            valid=true
            break
        fi
    done

    # verify ID
    if $valid; then
        print_done "Build ID is verified"
    else
        print_error "Invalid build ID"
        exit 1
    fi

    nh_rootfs="$PREFIX/var/lib/proot-distro/installed-rootfs/BackTrack-$BUILD_ID"

}

# Check if already installed-rootfs
is_distro_already_installed() {
    print_task_V1_7 "Finding installed nethunter"
    local DISTRO_PREFIX="BackTrack-"
    local distro=$DISTRO_PREFIX$1
    proot-distro login $distro -- whoami > /dev/null 2>&1
    not_installed=$?
}

get_device_status() {
    print_task_V1_7 "Fetching device info"
    # Define color codes
    local RED='\033[1;31m'
    local YELLOW='\033[1;33m'
    local GREEN='\033[1;32m'
    local NC='\033[0m' # No Color
    
    echo -e "Device RAM: $device_total_ram_gb GB"
    echo -e "Device Storage: $device_avilable_storage GB"
    echo -e ""
    
    if [[ $(echo "$device_total_ram_gb < 3" | bc -l) = 1 ]]; then
        echo -e "[${RED}!${NC}] ${YELLOW}WARNING:${NC} Device RAM is very low. Nethunter may not run smoothly on this device. It is recommended not to run heavy software inside Nethunter.\n"
    fi

    if [[ $(echo "$device_avilable_storage < 8" | bc -l) = 1 ]]; then
        echo -e "[${RED}!${NC}] ${YELLOW}WARNING:${NC} Device storage is very low. Please free up storage before installing Nethunter.\n"
    fi

}

# Check Device
get_device_architecture() {
    print_task_V1_7 "Checking device architecture"
    supported_arch=("arm64-v8a" "armeabi" "armeabi-v7a")
    device_arch=$(getprop ro.product.cpu.abi)

    if [[ " ${supported_arch[@]} " =~ " $device_arch " ]]; then
        case $device_arch in
            "arm64-v8a")
                SYS_ARCH="arm64"
                ;;
            "armeabi" | "armeabi-v7a")
                SYS_ARCH="armhf"
                ;;
        esac
        print_done "Device architecture: $SYS_ARCH"
    else
        print_error "Unsupported Architecture"
        exit 1
    fi
}

# Update termux
upgrade_termux() {
    print_task_V1_7 "Updating termux"
    printf "[\033[34;1m?\033[0m] Did you already have changed the termux repo ? (y/n) : \033[38;5;222m"; read ch_repo
    printf "\033[0m"

    case $ch_repo in
        y)
        # Do nothing
        ;;
        n)
        print_task_V1_7 "Changing termux repo"
        sleep 2
        termux-change-repo
        ;;
        *)
        print_error "Faild to change termux repo: Invalid choise: type y or n"
        exit 1
        ;;
    esac
    print_task_V1_7 "Installing required packages"
    apt update && apt full-upgrade -y
    apt install -y proot-distro curl
}

# Retrieve SHA256 checksum for the selected Nethunter image
get_sha256_checksum() {
    print_task_V1_7 "Retrieving SHA256 checksum"
    base_url="https://kali.download/nethunter-images/current/rootfs"
    sha256_url="$base_url/SHA256SUMS"
    rootfs="kalifs-$SYS_ARCH-minimal.tar.xz"
    
    SHA256=$(curl -s "$sha256_url" | grep "$rootfs" | awk '{print $1}')

    if [[ -z "$SHA256" ]]; then
        print_error "Failed to retrieve SHA256 checksum. Exiting."
        exit 1
    fi

    print_done "SHA256SUM: $SHA256"
}

# Generate and save the proot-distro configuration file
generate_config_file() {
    print_task_V1_7 "Generating config file"
    distro_file="# Kali nethunter $SYS_ARCH
DISTRO_NAME=\"kali Nethunter $BUILD_ID ($SYS_ARCH)\"
DISTRO_COMMENT=\"Kali nethunter $SYS_ARCH (ID: $BUILD_ID)\"
TARBALL_URL['aarch64']=\"$base_url/$rootfs\"
TARBALL_SHA256['aarch64']=\"$SHA256\""

    printf "$distro_file" > "$PREFIX/etc/proot-distro/BackTrack-$BUILD_ID.sh"
    if [ $? -eq 0 ]; then
    print_done "Successfully generated config file"
    fi
}
# Install nethunter
install_nethunter() {
    
    get_device_architecture
    upgrade_termux
    get_sha256_checksum
    generate_config_file
    proot-distro install BackTrack-$BUILD_ID
}

# Login Shortcut
login_shortcut() {
    print_task_V1_7 "Creating login shortcut"
    cp ./login $PREFIX/bin/nethunter
    chmod +x $PREFIX/bin/nethunter
    if [ $? -eq 0 ]; then
    print_done "Shortcut created as 'nethunter'"
    fi
}

# Setup Nethunter
setup_nethunter(){
    print_task_V1_7 "Setting up nethunter"
    # hide Kali developers message
    touch $nh_rootfs/root/.hushlogin
    touch $nh_rootfs/home/kali/.hushlogin
    
    # Fixed apt upgrade stuck by 'mv /usr/sbin/telinit /usr/sbin/telinit.bak2 && ln -s /usr/bin/true /usr/sbin/telinit' before upgrade the nethunter
    # discussions by tj64 : https://github.com/microsoft/WSL/discussions/11097#discussioncomment-8356353
    proot-distro login BackTrack-$BUILD_ID -- bash -c 'apt update
    mv /usr/sbin/telinit /usr/sbin/telinit.bak2
    ln -s /usr/bin/true /usr/sbin/telinit
    apt full-upgrade -y
    apt autoremove -y
    apt install -y apt-utils
    echo "kali    ALL=(ALL:ALL) ALL" > /etc/sudoers.d/kali'
    if [ $? -eq 0 ]; then
    print_done "NetHunter has been updated"
    fi
}

# Update default password
update_passwd(){
    print_task_V1_7 "Updating password (root)"
    proot-distro login BackTrack-$BUILD_ID -- passwd
    if [ $? -eq 0 ]; then
    print_done "Updated password for user root"
    fi
    print_task_V1_7 "Updating password (kali)"
    proot-distro login BackTrack-$BUILD_ID -- passwd kali
    if [ $? -eq 0 ]; then
    print_done "Updated password for user kali"
    fi
}

# Setup zsh prompt (ohmyzsh)
setup_zsh(){
    printf "[\033[34;1m?\033[0m] Apply nethunter theme to Termux? (y/n) : \033[38;5;222m"; read snt
    printf "\033[0m"

    case "$snt" in
        y|Y)
            if [ -f "$HOME/.termux/colors.properties" ]; then
                print_task_V1_7 "Backing up termux color properties"
                mv "$HOME/.termux/colors.properties" "$HOME/.termux/colors.properties-$current_datetime.bak"
                print_done "Backup done"
            fi
            print_task_V1_7 "Changing the color and font of Termux"
            cp "./themes/termux/colors.properties" "$HOME/.termux"
            cp "./themes/termux/font.ttf" "$HOME/.termux"
            print_done "Color update of termux is done"
            ;;
        *)
            # Do nothing
            ;;
    esac
    
    proot-distro login BackTrack-$BUILD_ID -- bash -c 'apt install -y zsh-syntax-highlighting zsh-autosuggestions command-not-found'
    proot-distro login BackTrack-$BUILD_ID -- bash -c 'apt update'
    if [ $? -eq 0 ]; then
    print_done "zsh setup is complete"
    fi
}

# Set up Nethunter GUI Xfce
gui_setup() {
    print_task_V1_7 "Setting up Nethunter GUI"
    # Add xstartup file
    cp "./VNC/xstartup" "$nh_rootfs/root/.vnc/"
    cp "./VNC/xstartup" "$nh_rootfs/home/kali/.vnc"
    # kgui executable
    cp "./VNC/kgui" "$nh_rootfs/usr/bin/"
    # Fix ㉿ symbol encoding issue on terminal
    cp "./themes/nethunter/NishikiTeki-font.ttf" "$nh_rootfs/usr/share/fonts/"

    proot-distro login BackTrack-$BUILD_ID -- bash -c 'chmod +x ~/.vnc/xstartup
    chmod +x /usr/bin/kgui'
    proot-distro login BackTrack-$BUILD_ID --user kali -- bash -c 'chmod +x ~/.vnc/xstartup'
    if [ $? -eq 0 ]; then
    print_done "GUI setup is complete"
    fi
}

change_default_shell() {
    print_task_V1_7 "Changing default shell to zsh"
    proot-distro login BackTrack-$BUILD_ID -- bash -c 'usermod -s /usr/bin/zsh root
    usermod -s /usr/bin/zsh kali'
    if [ $? -eq 0 ]; then
    print_done "Successfully changed default shell to zsh"
    else
        print_error "Faild to thange default shell"
    fi
}


# Function to Build nethunter based on the build ID
BUILD_NEW_NH() {
    case $BUILD_ID in
        KBDEXKMT10)
            # xfce top10
            local tools='Top 10'
            print_task_V1_7 "Building kali $tools"
            proot-distro login BackTrack-$BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-top10
            ;;
        KBDEXKMTD)
            # xfce default
            local tools='Default'
            print_task_V1_7 "Building kali $tools"
            proot-distro login BackTrack-$BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-linux-default
            ;;
        KBDEXKMTL)
            # xfce large
            local tools='Large'
            print_task_V1_7 "Building kali $tools"
            proot-distro login BackTrack-$BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-linux-large
            ;;
        KBDEXKMTE)
            # xfce everything
            local tools='Everything'
            print_task_V1_7 "Building kali $tools"
            proot-distro login BackTrack-$BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-linux-everything
            ;;
        KBCTDEX)
            #Custom Tools Build
            local tools='Custom build'
            print_task_V1_7 "Building kali with custom tools"
            proot-distro login BackTrack-$BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 tigervnc-standalone-server kali-defaults kali-themes kali-menu firefox-esr steghide sqlmap autopsy wireshark yara wfuzz enum4linux nmap ncat cewl john wordlists hydra ghidra jd-gui burpsuite nikto dirb wpscan python3 python3-pip socat gobuster villain
            ;;
        KBCIGDEX)
            #Information gathering
            local tools='Information gathering'
            print_task_V1_7 "Building kali $tools"
            proot-distro login BackTrack-$BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-information-gathering
            ;;
        KBCWGDEX)
            # kali web
            local tools='Web'
            print_task_V1_7 "Building kali $tools"
            proot-distro login BackTrack-$BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-web
            ;;
        KBCCSGDEX)
            #Crypto and Stego
            local tools='Crypto & Stego'
            print_task_V1_7 "Building kali $tools"
            proot-distro login BackTrack-$BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-crypto-stego
            ;;
        KBCPGDEX)
            #Passwords
            local tools='Password enumeration'
            print_task_V1_7 "Building kali $tools"
            proot-distro login BackTrack-$BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-passwords
            ;;
        KBCFOGDEX)
            #Forensics
            local tools='Forensics'
            print_task_V1_7 "Building kali $tools"
            proot-distro login BackTrack-$BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-forensics
            ;;
        KBCFUGDEX)
            #Fuzzing
            local tools='Fuzzing'
            print_task_V1_7 "Building kali $tools"
            proot-distro login BackTrack-$BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-fuzzing
            ;;
        KBCREGDEX)
            #Reverse engineering
            local tools='Reverse engineering'
            print_task_V1_7 "Building kali $tools"
            proot-distro login BackTrack-$BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-reverse-engineering
            ;;
        KBCSSGDEX)
            #Sniffing and Spoofing
            local tools='Sniffing & Spoofing'
            print_task_V1_7 "Building kali $tools"
            proot-distro login BackTrack-$BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-sniffing-spoofing
            ;;
        KBCEGDEX)
            # Exploit
            local tools='Exploitation'
            print_task_V1_7 "Building kali $tools"
            proot-distro login BackTrack-$BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-exploitation
            ;;
        *)
            print_error "Invalid build ID"
            exit 1
            ;;
    esac

    if [ $? -eq 0 ]; then
        print_done "kali NetHunter $tools is ready"
    else
        print_error "The building process is completed with some errors"
    fi
}


###################################################################
#                             RUNTIME                             #
###################################################################

RUN () {
    get_device_status
    get_build_ID
    is_distro_already_installed $BUILD_ID

    if [[ $not_installed == 0 ]]; then
        # continue as already installed
        echo -e "[\033[31;1m!\033[0m]\033[33m This version of nethunter is already installed\033[0m\n"
        printf "[\033[34;1m?\033[0m] Do you want to upgrade it ? (y/n) : \033[38;5;222m"; read upv
        printf "\033[0m"

        case $upv in
            y)
                set -e
                upgrade_termux
                login_shortcut
                setup_nethunter
                update_passwd
                printf "[\033[34;1m?\033[0m] Do you want to reinstall these softwares ? (y/n) : \033[38;5;222m"; read isa
                printf "\033[0m"
                case "$isa" in
                    y|Y)
                        BUILD_NEW_NH   
                    ;;
                    *)
                        # Do nothing
                    ;;
                esac
                setup_zsh
                gui_setup
                change_default_shell
            ;;
            *)
                print_done "Exiting.."
                exit 0
        esac
        
    elif [[ $not_installed == 1 ]]; then
        # install new one
        print_done "There is no previous version of nethunter on this device"
        set -e
        install_nethunter
        login_shortcut
        setup_nethunter
        update_passwd
        BUILD_NEW_NH
        setup_zsh
        gui_setup
        change_default_shell
    else
        print_error "value of the variable 'not_installed' should be 0 or 1"
        exit 1
    fi
}

if [[ $1 == "--install" ]]; then
    RUN
    if [ $? -eq 0 ]; then
        print_done "Installation Successfull"
        echo -e "Login with : \033[32mnethunter\033[0m [ BUILD ID ] [ USER ]"
        echo -e "Default user is \033[34mkali\033[0m\n"
    fi
else
    info
    exit 0
fi
