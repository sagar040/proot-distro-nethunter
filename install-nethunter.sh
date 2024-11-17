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
# Version: 1.8
# GitHub Repository: https://github.com/sagar040/proot-distro-nethunter
# License : https://raw.githubusercontent.com/sagar040/proot-distro-nethunter/main/LICENSE
# proot-distro-nethunter  Copyright (C) 2024  Sagar Biswas




# do the Architecture check before starting
supported_arch=("arm64-v8a" "armeabi" "armeabi-v7a")
device_arch=$(getprop ro.product.cpu.abi)

if [[ " ${supported_arch[@]} " =~ " $device_arch " ]]; then
    case $device_arch in
        "arm64-v8a")
            SYS_ARCH="arm64"
            TARBALL_ARCH="aarch64"
        ;;
        "armeabi" | "armeabi-v7a")
            SYS_ARCH="armhf"
            TARBALL_ARCH="arm"
        ;;
    esac
else
    print_error "This script cannot run on your device. Unsupported architecture '$device_arch'"
    exit 1
fi



SCRIPT_VERSION="1.8"
current_datetime=$(date +"%d.%m.%Y-%H:%M")


nh_image_path="$PREFIX/var/lib/proot-distro/dlcache"
nh_rootfs_path="$PREFIX/var/lib/proot-distro/installed-rootfs"
curl_image_path="file:///data/data/com.termux/files/home/.pdn-backup"
old_shortcut_checksum="e29579e737602bc1114093e306baf41750d38b03e2cf3a25046497ac61ac0082"


# List of valid build IDs
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

# Custom error msg
print_error() {
    local error_val=$1
    echo -e "\033[31;1mError:\033[0m $error_val\n"
}

# Custom task heading
print_task() {
    local task=$1
    local task_symbol="\033[38;5;246m[\033[38;5;228m#\033[38;5;246m]\033[0m"
    echo -e "$task_symbol \033[38;5;141m$task\033[0m"
}

# Custom done msg
print_done () {
    local msg=$1
    echo -e "[\033[32;1m\u2714\ufe0e\033[0m] $msg\n"
}


###################################################################
#                         BANNER ANIMATION                        #
###################################################################

# clear console
clear_console() {
    printf "\033c"
}

# banner lines for animation
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

# the animation function
animate_banner() {
    normal_color=$1
    body_color=$2
    bright_part=$3
    reset='\e[0m'
    
    clear
    tput civis
    
    for line in "${banner_lines[@]}"; do
        echo -e "${normal_color}${line}${reset}"
    done
    
    sleep 1.0
    
    for ((i=${#banner_lines[@]}-1; i>=0; i--)); do
        
        clear
        for ((j=0; j<${#banner_lines[@]}; j++)); do
            if [ $i -eq $j ]; then
                if [ $i -eq 0 ]; then
                    echo -e "${normal_color}${banner_lines[$j]}${reset}"
                else
                    echo -e "${bright_part}${banner_lines[$j]}${reset}"
                fi
            else
                echo -e "${body_color}${banner_lines[$j]}${reset}"
            fi
        done
        sleep 0.07
    done
}


# final Banner (base64 encoded because of color codes)
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

# spaces
sa1=$(printf '%*s' 15 '')
sa2=$(printf '%*s' 5 '')

# program name
echo -e "$sa1\e[38;5;231;1mPRoo\e[38;5;253;1mt D\e[38;5;251;1mis\e[38;5;248;1mtro \e[38;5;196;1mNet\e[38;5;160;1mhun\e[38;5;124;1mter\e[0m\n"
}

# informations
info() {
    echo -e "\e[38;5;250mInstall Kali Nethunter (official version) on proot-distro. you can create multiple Nethunters from the same image with custom tools.\033[0m\n"
    
    echo -e "\e[38;5;155;1mVersion: $SCRIPT_VERSION\033[0m"
    echo -e "\e[38;5;45mGithub Repo:\033[0m \e[38;5;253mgithub.com/sagar040/proot-distro-nethunter\033[0m"
    echo ""
    echo -e "\e[38;5;45mUsage:\033[0m $0 --install"
    echo -e ""
}

# Run the animations
animate_banner '\e[38;5;231m' '\e[38;5;231m' '\e[38;5;33;1m'
clear_console
print_banner_with_color
tput cnorm


###################################################################
#                           MAIN PROGRAMS                         #
###################################################################



# remove old shortcut file
rosf () {
    if [ -f "$PREFIX/bin/nethunter" ]; then
        old_shortcut_checksum_now=$(sha256sum "$PREFIX/bin/nethunter" | awk '{print $1}')
        if [[ $old_shortcut_checksum_now == $old_shortcut_checksum ]]; then
            rm $PREFIX/bin/nethunter
        fi
    fi
 }

# Update termux
upgrade_termux() {
    print_task "Updating termux"
    echo -e "\n## \033[32;1mOPTIONS\033[0m ##"
    echo -e "\033[38;5;222;1ma\033[0m - Auto select repo"
    echo -e "\033[38;5;222;1mm\033[0m - Manually select repo"
    echo -e "\033[38;5;222;1mn\033[0m - Don't change repo\n"
    printf "[\033[34;1m?\033[0m] Do you want to change termux repo ? (a/m/n) : \033[38;5;222m"; read ch_repo
    printf "\033[0m"

    case $ch_repo in
        a|A)
        echo 'deb https://grimler.se/termux/termux-main stable main' > $PREFIX/etc/apt/sources.list
        if [ $? -eq 0 ]; then
            print_done 'successfully changed termux repo'
        else
            print_error 'faild to change termux repo'
        fi
        ;;
        m|M)
        sleep 1
        termux-change-repo
        if [ $? -eq 0 ]; then
            print_done 'successfully changed termux repo'
        else
            print_error 'faild to change termux repo'
        fi
        ;;
        n|N)
        # Do nothing
        ;;
        *)
        print_error "Invalid choise!"
        exit 1
        ;;
    esac
    
    # install required packages
    apt update &> /dev/null || apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" dist-upgrade -y &> /dev/null
    apt install curl wget proot bc ncurses-utils proot-distro -y &> /dev/null
    print_done "termux successfully updated"
}


# get device status
get_device_status() {
    print_task "Fetching device info"
    
    # device status values
    device_avilable_storage=$(df -h | grep '/storage/emulated' | awk '{print $4}' | tr -d '[:alpha:]')
    device_total_ram=$(free -b | awk 'NR==2 {print $2}')
    device_total_ram_gb=$(echo "scale=2; $device_total_ram / (1024 * 1024 * 1024)" | bc)
    
    # Define color codes
    local RED='\033[1;31m'
    local YELLOW='\033[1;33m'
    local GREEN='\033[1;32m'
    local NC='\033[0m' # No Color
    
    echo -e "Device RAM: $device_total_ram_gb GB"
    echo -e "Device Storage: $device_avilable_storage GB"
    echo -e ""
    
    
    if [[ $(echo "$device_avilable_storage < 6" | bc -l) = 1 ]]; then
        echo -e "[${RED}!${NC}] ${RED}ABORT:${NC} Not enough storage. Free up device storage to install Nethunter.\n"
        exit 1;
    fi
    
    if [[ $(echo "$device_total_ram_gb < 3" | bc -l) = 1 ]]; then
        echo -e "[${RED}!${NC}] ${YELLOW}WARNING:${NC} Device RAM is very low. Nethunter may not run smoothly on this device. It is recommended not to run heavy software inside Nethunter.\n"
    fi
    
    if [[ $(echo "$device_avilable_storage < 9" | bc -l) = 1 ]]; then
        echo -e "[${RED}!${NC}] ${YELLOW}WARNING:${NC} Device storage is very low. Please free up storage before installing Nethunter.\n"
    fi
    
    print_done "checked device status"
}


get_build_ID() {
    print_task "Getting Build ID"
    # Prompt user for ID
    printf "[\033[32;1m*\033[0m] Get build ID from here : \033[38;5;252mhttps://github.com/sagar040/proot-distro-nethunter/blob/main/README.md#list-of-kali-nethunter-builds"
    echo -e "\033[0m\n"
    printf "[\033[34;1m?\033[0m] Enter a build ID : \033[38;5;222m"; read BUILD_ID
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
    
    nh_rootfs="$nh_rootfs_path/$BUILD_ID"
    nh_rootfs_image="$BUILD_ID.tar.xz"
}


# rename old distro
rename_old_distro() {
    old_distro="BackTrack-$1"
    proot-distro login $old_distro -- whoami > /dev/null 2>&1
    iodi=$?
    if [[ $iodi == 0 ]]; then
        proot-distro rename $old_distro $1
        print_done "renamed $old_distro as $1"
    fi
}


# Check if already installed-rootfs
is_distro_already_installed() {
    print_task "Finding installed nethunter"
    local distro=$1
    rename_old_distro $distro
    proot-distro login $distro -- whoami > /dev/null 2>&1
    not_installed=$?
    if [[ $not_installed == 1 ]]; then
        print_done "no previous distro found"
    fi
}


# Retrieve SHA512 checksum for the selected Nethunter image
get_sha512_checksum() {
    print_task "Retrieving SHA512 checksum"
    base_url="https://kali.download/nethunter-images/current/rootfs"
    rootfs="kali-nethunter-rootfs-minimal-$SYS_ARCH.tar.xz"
    sha512_url="$base_url/$rootfs.sha512sum"
    SHA512=$(curl -s -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36" "$sha512_url" | awk '{print $1}')
    if [[ -z "$SHA512" ]]; then
        print_error "Failed to retrieve SHA512 checksum. Exiting."
        exit 1
    fi
    print_done "SHA512SUM: \033[38;5;33m$SHA512\033[0m"
}


# download the Nethunter image file
download_image() {
    print_task "Downloading Nethunter Image"
    echo -e "[\033[38;5;33m*\033[0m] Please wait.."
    wget -P ~/.prdnh "$base_url/$rootfs" &> /dev/null
    download_error=$?
    
    if [[ $download_error == 0 ]]; then
        print_done "nethunter image downloaded successfully"
    else
        print_error "Failed to download the image"
        exit 1
    fi
}


# verify the image file
verify_image() {
    print_task "verify image"
    sha512_di=$(sha512sum ~/.prdnh/$rootfs | awk '{print $1}')
    echo -e "SHA512SUM: \033[38;5;33m$sha512_di\033[0m"
    if [[ $sha512_di == $SHA512 ]]; then
        print_done "signature verified"
    elif [[ $sha512_di != $SHA512 ]]; then
        print_error "signature not verified. downloaded file flagged as malicious ! Exiting.."
        rm -rf "~/.prdnh/$rootfs"
        exit 1
    fi
}

# fix and recompress image
rebuild_image() {
     # Print task information
    print_task "Rebuilding image for PRoot distro"
    
    echo -e "[\033[38;5;33m0%\033[0m] decompressing.. \033[33mplease wait\033[0m"
    # Decompress the archive
    # do not decompress with 'proot --link2symlink'. it will mess up system configuration.
    tar -xvf ~/.prdnh/$rootfs -C ~/.prdnh &> /dev/null
    echo -e "[\033[38;5;33m30%\033[0m] \033[32;1mdone\033[0m"
    
    echo -e "[\033[38;5;33m35%\033[0m] prossing.."
    # Move the directory
    mv ~/.prdnh/chroot/"kali-$SYS_ARCH" ~/.prdnh/
    if [ $? -ne 0 ]; then
        print_error "Failed to move directory"
        rm -rf ~/.prdnh
        exit 1
    else
        echo -e "[\033[38;5;33m40%\033[0m] \033[32;1mdone\033[0m"
    fi
    
    echo -e "[\033[38;5;33m45%\033[0m] recompressing.. \033[33mplease wait\033[0m"
    
    # Compress the directory
    tar -cvf ~/.prdnh/"kali-nethunter-proot-$SYS_ARCH.tar.xz" -J -C ~/.prdnh "kali-$SYS_ARCH" &> /dev/null
    
    if [ $? -ne 0 ]; then
        print_error "Failed to compress directory"
        rm -rf ~/.prdnh
        exit 1
    else
        echo -e "[\033[38;5;33m70%\033[0m] \033[32;1mdone\033[0m"
    fi
    
    echo -e "[\033[38;5;33m75%\033[0m] backing up.."
    
    # backup the image
    mkdir -p ~/.pdn-backup
    cp ~/.prdnh/"kali-nethunter-proot-$SYS_ARCH.tar.xz" ~/.pdn-backup/
    if [ $? -ne 0 ]; then
        print_error "Failed to backup the image file"
        rm -rf ~/.prdnh
        exit 1
    else
        echo -e "[\033[38;5;33m80%\033[0m] \033[32;1mdone\033[0m"
    fi

    echo -e "[\033[38;5;33m85%\033[0m] prossing.."
    # Create directory $PREFIX/var/lib/proot-distro/dlcache if it doesn't exist (This will be required if the user is installing the Prot distro for the first time)
    mkdir -p $nh_image_path

    # Move the compressed archive
    mv ~/.prdnh/"kali-nethunter-proot-$SYS_ARCH.tar.xz" $nh_image_path
    if [ $? -ne 0 ]; then
        print_error "Failed to move image file"
        rm -rf ~/.prdnh
        exit 1
    else
        echo -e "[\033[38;5;33m90%\033[0m] \033[32;1mdone\033[0m"
    fi
    
    echo -e "[\033[38;5;33m95%\033[0m] cleaning.."
    # Clean up
    rm -rf ~/.prdnh
    if [ $? -ne 1 ]; then
        echo -e "[\033[38;5;33m100%\033[0m] \033[32;1mDone\033[0m"
    fi
    
    # Print success message
    print_done "Successfully rebuilt the image"
}


generate_sha256() {
    print_task "Generating sha256sum"
    sha256_di=$(sha256sum "$nh_image_path/kali-nethunter-proot-$SYS_ARCH.tar.xz" | awk '{print $1}')
    print_done "SHA256SUM: \033[38;5;33m$sha256_di\033[0m"
    print_done "generated sha256sum"
}


# Generate and save the proot-distro configuration file
generate_config_file() {
    print_task "Generating config file"
    distro_file="# Kali nethunter $SYS_ARCH
DISTRO_NAME=\"kali Nethunter ($BUILD_ID) ($SYS_ARCH)\"
DISTRO_COMMENT=\"Kali nethunter $SYS_ARCH (ID: $BUILD_ID)\"
TARBALL_URL[\"$TARBALL_ARCH\"]=\"$curl_image_path/kali-nethunter-proot-$SYS_ARCH.tar.xz\"
TARBALL_SHA256[\"$TARBALL_ARCH\"]=\"$1\""

    printf "$distro_file" > "$PREFIX/etc/proot-distro/$BUILD_ID.sh"
    if [ $? -eq 0 ]; then
    print_done "Successfully generated config file"
    fi
}


# Login Shortcut
login_shortcut() {
    shortcut_name="kali-$1"
    print_task "Creating login shortcut"
    cp ./shortcut/login $PREFIX/bin/$shortcut_name
    chmod +x $PREFIX/bin/$shortcut_name
    sed -i "/^nh_distro=/c nh_distro=\"$BUILD_ID\"" $PREFIX/bin/$shortcut_name
    if [ $? -eq 0 ]; then
    print_done "Shortcut created as \033[38;5;46m$shortcut_name\033[0m"
    fi
}


# Setup Nethunter
setup_nethunter(){
    print_task "Setting up nethunter"
    # hide Kali developers message
    touch $nh_rootfs/root/.hushlogin
    touch $nh_rootfs/home/kali/.hushlogin
    
    # Fixed apt stucked in setting up libc6
    # stackoverflow : https://stackoverflow.com/questions/77781232/apt-stucked-in-setting-up-libc6#comment137269112_77781232
    # discussions by tj64 : https://github.com/microsoft/WSL/discussions/11097#discussioncomment-8356353
    proot-distro login $BUILD_ID -- bash -c 'mv /usr/sbin/telinit /usr/sbin/telinit.bak2
    ln -s /usr/bin/true /usr/sbin/telinit
    apt update
    apt full-upgrade -y
    apt autoremove -y
    apt install -y apt-utils
    echo "kali    ALL=(ALL:ALL) ALL" > /etc/sudoers.d/kali'
    if [ $? -eq 0 ]; then
        print_done "Successfully setup nethunter"
    else
        print_error "Faild to setup nethunter"
        exit 1
    fi
}


# Update default password
update_passwd(){
    print_task "Updating password"
    echo -e "[\033[38;5;33m*\033[0m] set new password for user \033[38;5;33mroot\033[0m"
    proot-distro login $BUILD_ID -- passwd
    if [ $? -eq 0 ]; then
        print_done "Updated password for user root"
    else
        print_error "Faild update password for root"
    fi
    echo -e "[\033[38;5;33m*\033[0m] set new password for user \033[38;5;33mkali\033[0m"
    proot-distro login $BUILD_ID -- passwd kali
    if [ $? -eq 0 ]; then
        print_done "Updated password for user kali"
    else
        print_error "Faild update password for kali"
    fi
}


# Function to Build nethunter based on the build ID
BUILD_NH() {
    case $BUILD_ID in
        KBDEXKMT10)
            # xfce top10
            local tools='Top 10'
            print_task "Building kali $tools"
            proot-distro login $BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-top10
            login_shortcut 'top10'
            ;;
        KBDEXKMTD)
            # xfce default
            local tools='Default'
            print_task "Building kali $tools"
            proot-distro login $BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-linux-default
            login_shortcut 'default'
            ;;
        KBDEXKMTL)
            # xfce large
            local tools='Large'
            print_task "Building kali $tools"
            proot-distro login $BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-linux-large
            login_shortcut 'large'
            ;;
        KBDEXKMTE)
            # xfce everything
            local tools='Everything'
            print_task "Building kali $tools"
            proot-distro login $BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-linux-everything
            login_shortcut 'everything'
            ;;
        KBCTDEX)
            # Custom Tools Build
            local tools='Custom build'
            print_task "Building kali with custom tools"
            proot-distro login $BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 tigervnc-standalone-server kali-defaults kali-themes kali-menu firefox-esr steghide sqlmap autopsy wireshark yara wfuzz enum4linux nmap ncat cewl john wordlists hydra ghidra jd-gui burpsuite nikto dirb wpscan python3 python3-pip socat gobuster villain
            login_shortcut 'custom'
            ;;
        KBCIGDEX)
            # Information gathering
            local tools='Information gathering'
            print_task "Building kali $tools"
            proot-distro login $BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-information-gathering
            login_shortcut 'info-gather'
            ;;
        KBCWGDEX)
            # kali web
            local tools='Web'
            print_task "Building kali $tools"
            proot-distro login $BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-web
            login_shortcut 'web'
            ;;
        KBCCSGDEX)
            # Crypto and Stego
            local tools='Crypto & Stego'
            print_task "Building kali $tools"
            proot-distro login $BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-crypto-stego
            login_shortcut 'crypto-stego'
            ;;
        KBCPGDEX)
            # Passwords
            local tools='Password enumeration'
            print_task "Building kali $tools"
            proot-distro login $BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-passwords
            login_shortcut 'pass-enum'
            ;;
        KBCFOGDEX)
            # Forensics
            local tools='Forensics'
            print_task "Building kali $tools"
            proot-distro login $BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-forensics
            login_shortcut 'forensics'
            ;;
        KBCFUGDEX)
            # Fuzzing
            local tools='Fuzzing'
            print_task "Building kali $tools"
            proot-distro login $BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-fuzzing
            login_shortcut 'fuzzing'
            ;;
        KBCREGDEX)
            # Reverse engineering
            local tools='Reverse engineering'
            print_task "Building kali $tools"
            proot-distro login $BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-reverse-engineering
            login_shortcut 'reverse-engineering'
            ;;
        KBCSSGDEX)
            # Sniffing and Spoofing
            local tools='Sniffing & Spoofing'
            print_task "Building kali $tools"
            proot-distro login $BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-sniffing-spoofing
            login_shortcut 'sniff-spoof'
            ;;
        KBCEGDEX)
            # Exploit
            local tools='Exploitation'
            print_task "Building kali $tools"
            proot-distro login $BUILD_ID -- apt install -y kali-linux-core xfce4 xfce4-goodies xfce4-terminal kali-desktop-xfce xfce4-whiskermenu-plugin dbus-x11 kali-defaults kali-themes kali-menu firefox-esr tigervnc-standalone-server kali-tools-exploitation
            login_shortcut 'exploitation'
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


# Setup zsh prompt (ohmyzsh)
setup_zsh(){
    printf "[\033[34;1m?\033[0m] Apply nethunter theme to Termux? (y/n) : \033[38;5;222m"; read snt
    printf "\033[0m"

    case "$snt" in
        y|Y)
            if [ -f "$HOME/.termux/colors.properties" ]; then
                print_task "Backing up termux color properties"
                mv "$HOME/.termux/colors.properties" "$HOME/.termux/colors.properties-$current_datetime.bak"
                print_done "Backup done"
            fi
            print_task "Changing the color and font of Termux"
            cp "./themes/termux/colors.properties" "$HOME/.termux"
            cp "./themes/termux/font.ttf" "$HOME/.termux"
            print_done "Color update of termux is done"
            ;;
        *)
            # Do nothing
            ;;
    esac
    
    print_task "zsh setup"
    proot-distro login $BUILD_ID -- bash -c 'apt install -y zsh-syntax-highlighting zsh-autosuggestions command-not-found'
    proot-distro login $BUILD_ID -- bash -c 'apt-file update && apt update'
    if [ $? -eq 0 ]; then
        print_done "zsh setup is complete"
    else
        print_error "Faild to setup zsh"
    fi
}


# Set up Nethunter GUI Xfce
gui_setup() {
    print_task "Setting up Nethunter GUI"
    # Add xstartup file
    cp "./VNC/xstartup" "$nh_rootfs/root/.vnc/"
    cp "./VNC/xstartup" "$nh_rootfs/home/kali/.vnc"
    # kgui executable
    cp "./VNC/kgui" "$nh_rootfs/usr/bin/"
    # Fix ㉿ symbol encoding issue on terminal
    cp "./themes/nethunter/NishikiTeki-font.ttf" "$nh_rootfs/usr/share/fonts/"

    proot-distro login $BUILD_ID -- bash -c 'chmod +x ~/.vnc/xstartup
    chmod +x /usr/bin/kgui'
    proot-distro login $BUILD_ID --user kali -- bash -c 'chmod +x ~/.vnc/xstartup'
    if [ $? -eq 0 ]; then
        print_done "GUI setup is complete"
    else
        print_error "Faild to setup GUI, graphical interface may not work."
    fi
}


change_default_shell() {
    print_task "Changing default shell to zsh"
    proot-distro login $BUILD_ID -- bash -c 'usermod -s /usr/bin/zsh root
    usermod -s /usr/bin/zsh kali'
    if [ $? -eq 0 ]; then
    print_done "Default shell is zsh"
    else
        print_error "Faild to change default shell"
    fi
}

# pre installation process
pre_installation_process() {
    get_sha512_checksum
    download_image
    verify_image
    rebuild_image
}

# installation process
installation_process() {
    generate_sha256
    generate_config_file $sha256_di
    proot-distro install $BUILD_ID
}

# post installation process
post_installation_process() {
    set -e
    rm "$nh_image_path/kali-nethunter-proot-$SYS_ARCH.tar.xz"
    setup_nethunter
    update_passwd
    BUILD_NH
    setup_zsh
    gui_setup
    change_default_shell
}

install_new_nh() {
    # checking for backup image and install
    if [[ -f ~/.pdn-backup/kali-nethunter-proot-$SYS_ARCH.tar.xz ]]; then
        print_task "Select nethunter image"
        echo -e "\n[\033[32m*\033[0m] \033[34mBackup image found.\033[0m"

        echo -e "\n## \033[32;1mOPTIONS\033[0m ##"
        echo -e "\033[38;5;222;1mn\033[0m - Install new nethunter image"
        echo -e "\033[38;5;222;1mb\033[0m - Use the backup image\n"

        printf "[\033[34;1m?\033[0m] Select an option (n/b) : \033[38;5;222m"; read ci
        printf "\033[0m"

        case "$ci" in
            n|N)
                pre_installation_process
                ;;
            b|B)
                # copy the backup image
                cp ~/.pdn-backup/"kali-nethunter-proot-$SYS_ARCH.tar.xz" $nh_image_path
                if [ $? -eq 0 ]; then
                    print_done "Done"
                else
                    print_error "Faild to copy the backup image"
                    exit 1
                fi
                ;;
            *)
                print_error "Invalid choise"
                exit 1
                ;;
        esac
    else
        pre_installation_process
    fi
    installation_process
    post_installation_process  
}


###################################################################
#                             RUNTIME                             #
###################################################################

# final
if [[ $1 == "--install" ]]; then
    # common tasks
    rosf
    upgrade_termux
    get_device_status
    get_build_ID
    is_distro_already_installed $BUILD_ID
    
    # separate tasks
    if [[ $not_installed == 0 ]]; then
        # distro already installed
        echo -e "[\033[31;1m!\033[0m]\033[33m This version of nethunter is already installed\033[0m"
        echo -e "\n## \033[32;1mOPTIONS\033[0m ##"
        echo -e "\033[38;5;222;1mu\033[0m - Upgrade the old distro."
        echo -e "\033[38;5;222;1mr\033[0m - Reinstall nethunter."
        echo -e "\033[38;5;222;1ma\033[0m - Abort\n"
        printf "[\033[34;1m?\033[0m] Enter an option (it may change some settings). (u/r/a) : \033[38;5;222m"; read upv
        printf "\033[0m"
        
        case $upv in
            u|U)
                set -e
                BUILD_NH
                setup_zsh
                gui_setup
                change_default_shell
                if [ $? -eq 0 ]; then
                    print_done "Successfully updated"
                    echo -e "Login with : \033[32m$shortcut_name\033[0m [ USER ]"
                    echo -e "Default user is \033[34mkali\033[0m\n"
                else
                    print_error "Faild to update"
                fi
            ;;
            r|R)
                # remove old distro and clean for reinstall process
                # remove the old distro
                echo -e "[\033[38;5;196;1m-\033[0m] removing old distro"
                proot-distro remove $BUILD_ID
                if [ $? -eq 0 ]; then
                    print_done "Done"
                else
                    print_done "Faild to remove old distro"
                    exit 1
                fi

                # remove the config file
                echo -e "[\033[38;5;196;1m-\033[0m] removing config file"
                rm "$PREFIX/etc/proot-distro/$BUILD_ID.sh"
                if [ $? -eq 0 ]; then
                    print_done "Done"
                else
                    print_done "Faild to remove config file"
                    exit 1
                fi

                # reinstall
                install_new_nh
            ;;
            a|A)
                print_done "\033[31;1mAborting..\033[0m"
                exit 0
            ;;
            *)
                print_error "Invalid choise!"
                exit 1
        esac
        
    elif [[ $not_installed == 1 ]]; then
        install_new_nh
        if [ $? -eq 0 ]; then
            print_done "Installation Successfull"
            echo -e "Login with : \033[32m$shortcut_name\033[0m [ USER ]"
            echo -e "Default user is \033[34mkali\033[0m\n"
        else
            print_error "Faild to install nethunter."
        fi
    else
        print_error "value of the variable 'not_installed' should be 0 or 1"
        print_error "there are some issue. contact the developer."
        exit 1
    fi
else
    info
    exit 0
fi