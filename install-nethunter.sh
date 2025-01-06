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
# Version: 1.9
# GitHub Repository: https://github.com/sagar040/proot-distro-nethunter
# License : https://raw.githubusercontent.com/sagar040/proot-distro-nethunter/main/LICENSE
# Forks must be distributed under different name.


# Custom error msg
print_error() {
    local error_val=$1
    echo -e "\033[31;1mError:\033[0m $error_val\n"
}

# Custom task heading
print_task() {
    local task=$1
    local task_symbol="\033[38;5;246m[\033[38;5;228m#\033[38;5;246m]\033[0m"
    echo -e "$task_symbol \033[38;5;141m$task\033[0m\n"
}

# Custom done msg
print_done () {
    local msg=$1
    echo -e "[\033[32;1m\u2714\ufe0e\033[0m] $msg\n"
}


# do the Architecture check before starting
supported_arch=("arm64-v8a" "armeabi" "armeabi-v7a")
device_arch=$(getprop ro.product.cpu.abi)
if [ $? -ne 0 ]; then
    device_arch=$(uname -m)
fi

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
    print_error "This script cannot run on your device. Unsupported architecture '$(uname -m)'"
    exit 1
fi


# Config file
CONFIG_FILE="./config/config.json"

# Check if the config.json file exists and is not empty
if [[ ! -f "$CONFIG_FILE" ]]; then
    print_error "$CONFIG_FILE does not exist in the current directory."
    exit 1
elif [[ ! -s "$CONFIG_FILE" ]]; then
    print_error "$CONFIG_FILE is empty."
    exit 1
fi

# Extract values from JSON using jq
# version
SCRIPT_VERSION=$(jq -r '.VERSION' "$CONFIG_FILE")
# storage fail safe
STORAGE_FAIL_SAFE=$(jq -r '.STORAGE_FAIL_SAFE' "$CONFIG_FILE")
# nh image path
nh_image_path=$(jq -r '.nh_image_path' "$CONFIG_FILE")
# nh rootfs dir path
nh_rootfs_path=$(jq -r '.nh_rootfs_path' "$CONFIG_FILE")
# url for curl the local image
curl_image_path=$(jq -r '.curl_image_path' "$CONFIG_FILE")
# old shortcut checksum
old_shortcut_checksum=$(jq -r '.old_shortcut_checksum' "$CONFIG_FILE")
# config image verification
IMAGE_VERIFICATION=$(jq -r '.IMAGE_VERIFICATION' "$CONFIG_FILE")
# config image fixing
IMAGE_FIXING=$(jq -r '.IMAGE_FIXING' "$CONFIG_FILE")
# config termux repo (auto select)
termux_repo_auto=$(jq -r '.termux_repo_auto' "$CONFIG_FILE")
# nethunter resource
nh_resource=$(jq -r '.nh_resource' "$CONFIG_FILE")
# tmp storage dir
tmp_storage=$(jq -r '.tmp_storage' "$CONFIG_FILE")
# image backup dir
image_backup_dir=$(jq -r '.image_backup_dir' "$CONFIG_FILE")


# Ensure values are not empty
for var in SCRIPT_VERSION STORAGE_FAIL_SAFE nh_image_path nh_rootfs_path curl_image_path old_shortcut_checksum IMAGE_VERIFICATION IMAGE_FIXING termux_repo_auto nh_resource tmp_storage image_backup_dir; do
    if [ "${!var}" = "null" ] || [ -z "${!var}" ]; then
        print_error "Missing or empty required fields in $CONFIG_FILE"
        exit 1
    fi
done

# List of valid build IDs
declare -A valid_ids=(
    ["KBDEXKMT10"]=6.7
    ["KBDEXKMTD"]=13.0
    ["KBDEXKMTL"]=20.0
    ["KBDEXKMTE"]=34.0
    ["KBCTDEX"]=7.5
    ["KBCIGDEX"]=4.8
    ["KBCWGDEX"]=4.8
    ["KBCCSGDEX"]=4.8
    ["KBCPGDEX"]=4.8
    ["KBCFOGDEX"]=4.8
    ["KBCFUGDEX"]=4.8
    ["KBCREGDEX"]=4.8
    ["KBCSSGDEX"]=4.8
    ["KBCEGDEX"]=4.8
)

# Current date time
current_datetime=$(date +"%d.%m.%Y-%H:%M")


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
    echo -e "## \033[32;1mOPTIONS\033[0m ##"
    echo -e "\033[38;5;222;1ma\033[0m - Auto select repo"
    echo -e "\033[38;5;222;1mm\033[0m - Manually select repo"
    echo -e "\033[38;5;222;1mn\033[0m - Don't change repo\n"
    printf "[\033[34;1m?\033[0m] Do you want to change termux repo ? (a/m/n) : \033[38;5;222m"; read ch_repo
    printf "\033[0m"

    case $ch_repo in
        a|A)
        echo "deb $termux_repo_auto stable main" > $PREFIX/etc/apt/sources.list
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
    # Define color codes
    local RED='\033[1;31m'
    local GREEN='\033[1;32m'
    local YELLOW='\033[1;33m'
    local BLUE='\033[34m'
    local NC='\033[0m' # No Color
    
    # device storage
    storage_stats=$(df -k /data | tail -1)
    total_storage_raw=$(echo "$storage_stats" | awk '{print $2}')
    used_storage_raw=$(echo "$storage_stats" | awk '{print $3}')
    available_storage_raw=$(echo "$storage_stats" | awk '{print $4}')
    # format
    total_storage=$(printf "%.2f" $(bc <<< "scale=2; $total_storage_raw/1024/1024"))
    used_storage=$(printf "%.2f" $(bc <<< "scale=2; $used_storage_raw/1024/1024"))
    available_storage=$(printf "%.2f" $(bc <<< "scale=2; $available_storage_raw/1024/1024"))
    
    # device ram
    total_ram_raw=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    free_ram_raw=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    # format
    total_ram=$(printf "%.2f" $(bc <<< "scale=2; $total_ram_raw/1024/1024"))
    free_ram=$(printf "%.2f" $(bc <<< "scale=2; $free_ram_raw/1024/1024"))
    
    # device storage
    print_task "Fetching device storage info"
    echo -e "Total Storage: $total_storage GB"
    echo -e "Used Storage: $used_storage GB"
    echo -e "Available Storage: $BLUE$available_storage$NC GB"
    echo -e ""
    
    if [[ $(echo "$available_storage < 4" | bc -l) = 1 ]]; then
        echo -e "[${RED}!${NC}] ${RED}ABORT:${NC} Not enough storage. Free up device storage to install Nethunter.\n"
        exit 1;
    fi
    
    if [[ $(echo "$available_storage < 13" | bc -l) = 1 ]]; then
        echo -e "[${RED}!${NC}] ${YELLOW}WARNING:${NC} Device storage is very low. Please free up storage before installing Nethunter.\n"
    fi
    
    # device ram
    print_task "Fetching device RAM info"
    echo -e "Total RAM: $total_ram GB"
    echo -e "Free RAM: $BLUE$free_ram$NC GB"
    echo -e ""
    
    if [[ $(echo "$free_ram < 3" | bc -l) = 1 ]]; then
        echo -e "[${RED}!${NC}] ${YELLOW}WARNING:${NC} Device RAM is very low. Nethunter may not run smoothly on this device. It is recommended not to run heavy software inside Nethunter.\n"
    fi
    
    print_done "checked device status"
}

list_installable() {
    
    # Print table header
    printf "+------------+-----------------------+----------+\n"
    printf "| Build ID   | Required storage (GB) | Fulfills |\n"
    printf "+------------+-----------------------+----------+\n"
    # printf "| %-10s | %-20s | %-10s |\n" "ID" "Required storage (GB)" "Installable"

    # Check each ID
    for id in "${!valid_ids[@]}"; do
        required_storage=${valid_ids[$id]}
        
        if (( $(echo "$available_storage >= $required_storage" | bc -l) )); then
            # Green for "Yes"
            installable="\033[32mYes\033[0m"
        else
            # Red for "No"
            installable="\033[31mNo\033[0m"
        fi
        printf "| %-10s | %-21.2f | %-17b |\n" "$id" "$required_storage" "$installable"
    done
    # Print table footer
    printf "+------------+-----------------------+----------+\n"
}

get_build_ID() {
    print_task "Getting Build ID"
    list_installable
    printf "[\033[32;1m*\033[0m] More info : \033[38;5;252mhttps://github.com/sagar040/proot-distro-nethunter/blob/main/README.md#list-of-kali-nethunter-builds"
    echo -e "\033[0m\n"
    printf "[\033[34;1m?\033[0m] Enter a build id : \033[38;5;222m"; read BUILD_ID
    printf "\033[0m"

    # verify ID
    if [[ -n "${valid_ids[$BUILD_ID]}" ]]; then
        print_done "Build ID is verified"
        # fail safe
        if [ "${STORAGE_FAIL_SAFE:-}" == "true" ]; then
            # check if storage available
            local required_storage_for_id=${valid_ids[$BUILD_ID]}
            if (( $(echo "$available_storage >= $required_storage_for_id" | bc -l) )); then
                nh_rootfs="$nh_rootfs_path/$BUILD_ID"
                nh_rootfs_image="$BUILD_ID.tar.xz"
            else
                print_error "Not enough space to build Nethunter with ID '$BUILD_ID' (\033[38;5;51mSTORAGE FAIL SAFE\033[0m)."
                exit 1
            fi
        else
            echo -e "\033[38;5;196mWARNING\033[0m: Installing without considering storage because 'STORAGE_FAIL_SAFE' is set to false or unset at config/config.json\n"
            nh_rootfs="$nh_rootfs_path/$BUILD_ID"
            nh_rootfs_image="$BUILD_ID.tar.xz"
        fi
    else
        print_error "Invalid build ID"
        exit 1
    fi
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
    base_url=$nh_resource
    latest_release_url=$(curl -s "$base_url" | grep -oP '(?<=href=")kali-\d{4}\.\d+/' | sort -V | tail -n 1)
    if [[ -n "$latest_release_url" ]]; then
        latest_url="${base_url}${latest_release_url}"
    else
        print_error "Failed to retrieve the latest version URL"
        exit 1
    fi
    y_release=$(echo "$latest_release_url" | sed 's|kali-||; s|/||')
    rootfs="kali-nethunter-$y_release-rootfs-minimal-$SYS_ARCH.tar.xz"
    sha512_url="$latest_url$rootfs.sha512sum"
    SHA512=$(curl -s "$sha512_url" | awk '{print $1}')
    if [[ -z "$SHA512" ]]; then
        print_error "Failed to retrieve SHA512 checksum. Exiting."
        echo -e "\033[34;1mINFO\033[0m:\033[31m"
        echo "$(curl -vv "$sha512_url")"
        echo -e "\033[0m"
        exit 1
    fi
    # Regular expression for SHA-512 (128 hex characters)
    if [[ $SHA512 =~ ^[a-fA-F0-9]{128}$ ]]; then
        print_done "Nethunter Release: \033[38;5;51m$y_release\033[0m"
        print_done "SHA512SUM: \033[38;5;33m$SHA512\033[0m"
    else
        print_error "Failed to retrieve a valid SHA-512 checksum! (Not a SHA512SUM)"
        echo -e "\033[34;1mINFO\033[0m:\033[31m"
        echo "$(curl -vv "$sha512_url")"
        echo -e "\033[0m"
        exit 1
    fi
}


# download the Nethunter image file
download_image() {
    print_task "Downloading Nethunter Image"
    echo -e "[\033[38;5;33m*\033[0m] Please wait.."
    wget -P $tmp_storage "$latest_url/$rootfs" &> /dev/null
    
    if [ $? -eq 0 ]; then
        print_done "nethunter image downloaded successfully"
    else
        print_error "Failed to download the image"
        rm -rf $tmp_storage
        exit 1
    fi
}


# verify the image file
verify_image() {
    if [ "${IMAGE_VERIFICATION:-}" == "true" ]; then
        print_task "verify image"
        sha512_di=$(sha512sum $tmp_storage/$rootfs | awk '{print $1}')
        echo -e "SHA512SUM: \033[38;5;33m$sha512_di\033[0m"
        if [[ $sha512_di == $SHA512 ]]; then
            print_done "signature verified"
        elif [[ $sha512_di != $SHA512 ]]; then
            print_error "signature not verified. downloaded file flagged as malicious ! Exiting.."
            rm -rf $tmp_storage
            exit 1
        fi
    else
        echo -e "\033[38;5;196mWARNING\033[0m: Avoiding image verification because 'IMAGE_VERIFICATION' is set to false or unset at config/config.json\n"
    fi
}

# fix the image structure
fix_image() {
    if [ "${IMAGE_FIXING:-}" == "true" ]; then
        print_task "Fixing image.."
        # Define the default root filesystem directories
        DEFAULT_DIRS=(boot dev etc home media mnt opt proc root run srv sys tmp usr var)
        # the image file path
        ARCHIVE="$tmp_storage/$rootfs"

        # Check if the archive exists
        if [ ! -f "$ARCHIVE" ]; then
            print_error "Archive file '$ARCHIVE' not found."
            rm -rf $tmp_storage
            exit 1
        else
            print_done "Archive file: $ARCHIVE"
        fi

        echo -e "[\033[38;5;33m0%\033[0m] Scanning \033[33m$ARCHIVE\033[0m"
        # List top-level directories in the archive
        subdirs=($(tar -tf "$ARCHIVE" --xz | grep "/$" | awk -F'/' '{print $1}' | uniq))
        if [ $? -ne 0 ]; then
            print_error "Failed to read $ARCHIVE"
            rm -rf $tmp_storage
            exit 1
        fi

        # Check if there is exactly one top-level directory (valid format)
        if [ ${#subdirs[@]} -eq 1 ]; then
            root_dir="${subdirs[0]}/"
            echo -e "$ARCHIVE \033[32;1m=>\033[0m $root_dir \033[38;5;33m(single directory detected)\033[0m\n"

            echo -e "[\033[38;5;33m5%\033[0m] Scanning \033[33m$root_dir\033[0m"
            # List directories directly under the detected root directory
            inner_subdirs=($(tar -tf "$ARCHIVE" --xz | awk -F'/' -v prefix="$root_dir" '$0 ~ "^"prefix"[^/]+/$" {print $2}' | uniq))
            if [ $? -ne 0 ]; then
                print_error "Failed to get list at inner_subdirs"
                rm -rf $tmp_storage
                exit 1
            fi

            if [ ${#inner_subdirs[@]} -eq 1 ]; then
                chroot_dir="${inner_subdirs[0]}/"
                echo -e "$ARCHIVE \033[32;1m=>\033[0m $root_dir \033[32;1m=>\033[0m $chroot_dir \033[38;5;33m(single directory detected)\033[0m\n"
                echo -e "[\033[38;5;33m15%\033[0m] \033[33mProceeding with validation\033[0m"
                # List directories inside the chroot directory
                chroot_inner_subdirs=($(tar -tf "$ARCHIVE" --xz | awk -v prefix="$root_dir$chroot_dir" '$0 ~ "^"prefix"[^/]+/$" {sub(prefix, "", $0); gsub(/\/$/, "", $0); print $1}' | uniq))
                if [ $? -ne 0 ]; then
                    print_error "Failed to get list at chroot_inner_subdirs"
                    rm -rf $tmp_storage
                    exit 1
                fi

                # Validate if the inner directories match the default root filesystem structure
                for dir in "${DEFAULT_DIRS[@]}"; do
                    if ! printf "%s\n" "${chroot_inner_subdirs[@]}" | grep -qx "$dir"; then
                        print_error "Missing required directory '$dir' in '$root_dir$chroot_dir'."
                        rm -rf $tmp_storage
                        exit 1
                    fi
                done
                echo -e "[\033[38;5;33m20%\033[0m] \033[32;1mValid root filesystem\033[0m \033[34;1m$ARCHIVE\033[0m \033[32;1m=>\033[0m \033[33m$root_dir$chroot_dir\033[0m"
            
                echo -e "[\033[38;5;33m25%\033[0m] decompressing.. \033[33mplease wait\033[0m"
                # Decompress the archive
                # do not decompress with 'proot --link2symlink'.
                tar -xvf "$ARCHIVE" -C $tmp_storage &> /dev/null
                case $? in
                    0|2)
                        # continue 
                        ;;
                    *)
                        print_error "Failed to decompress $ARCHIVE"
                        rm -rf $tmp_storage
                        exit 1
                        ;;
                esac
                echo -e "[\033[38;5;33m40%\033[0m] \033[32;1mdone\033[0m"

                echo -e "[\033[38;5;33m42%\033[0m] prossing.."
                # Rename the chroot directory to match the top-level root directory
                mv "$tmp_storage/$root_dir$chroot_dir" "$tmp_storage/$root_dir$root_dir"
                if [ $? -ne 0 ]; then
                    print_error "Failed to rename directory $tmp_storage/$root_dir$chroot_dir to $tmp_storage/$root_dir$root_dir"
                    rm -rf $tmp_storage
                    exit 1
                else
                    echo -e "[\033[38;5;33m48%\033[0m] \033[32;1mdone\033[0m"
                fi

                # Create the new archive
                echo -e "[\033[38;5;33m50%\033[0m] recompressing.. \033[33mthis may take a while, please wait.\033[0m"
                tar -cvf "$tmp_storage/kali-nethunter-proot-$SYS_ARCH.tar.xz" -J -C "$tmp_storage/$root_dir" "$root_dir" &> /dev/null
                if [ $? -ne 0 ]; then
                    print_error "Failed to compress archive"
                    rm -rf $tmp_storage
                    exit 1
                fi
                echo -e "[\033[38;5;33m65%\033[0m] \033[32;1mdone\033[0m"
    
                # Print success message
                print_done "Successfully rebuilt the image"

            elif [ ${#inner_subdirs[@]} -gt 1 ]; then
                echo -e "[\033[38;5;33m40%\033[0m] \033[33mProceeding with validation\033[0m"

                # Validate if the inner directories match the default root filesystem structure
                for dir in "${DEFAULT_DIRS[@]}"; do
                    if ! printf "%s\n" "${inner_subdirs[@]}" | grep -qx "$dir"; then
                        print_error "Missing required directory '$dir' in '$root_dir'."
                        rm -rf $tmp_storage
                        exit 1
                    fi
                done
                echo -e "[\033[38;5;33m50%\033[0m] \033[32;1mValid root filesystem structure detected\033[0m"
                print_done "Nothing to fix.."
                echo -e "[\033[38;5;33m60%\033[0m] Renaming archive.."
                mv "$ARCHIVE" "$tmp_storage/kali-nethunter-proot-$SYS_ARCH.tar.xz"
                if [ $? -ne 0 ]; then
                    print_error "Faild to rename archive"
                    rm -rf $tmp_storage
                    exit 1
                else
                    echo -e "[\033[38;5;33m65%\033[0m] \033[32;1mdone\033[0m"
                fi
            else
                print_error "No inner directories found under '$root_dir'."
                rm -rf $tmp_storage
                exit 1
            fi
        else
            # Multiple top-level directories found (invalid format)
            print_error "Multiple top-level directories detected. This is not a valid format (rootfs)."
            echo -e "\033[38;5;33mINFO\033[0m: Please check the image file at $ARCHIVE. and contact the developer."
            exit 1
        fi
    else
        echo -e "[\033[38;5;33m0%\033[0m] \033[38;5;196mWARNING\033[0m: Avoiding image fixing process because 'IMAGE_FIXING' is set to false or unset at config/config.json\n"
        
        ARCHIVE="$tmp_storage/$rootfs"

        # Check if the archive exists
        if [ ! -f "$ARCHIVE" ]; then
            print_error "Archive file '$ARCHIVE' not found."
            rm -rf $tmp_storage
            exit 1
        else
            print_done "Archive file: $ARCHIVE"
        fi
        
        # rename
        echo -e "[\033[38;5;33m60%\033[0m] Renaming archive.."
        mv "$ARCHIVE" "$tmp_storage/kali-nethunter-proot-$SYS_ARCH.tar.xz"
        if [ $? -ne 0 ]; then
            print_error "Faild to rename archive"
            rm -rf $tmp_storage
            exit 1
        else
            echo -e "[\033[38;5;33m65%\033[0m] \033[32;1mdone\033[0m"
        fi
    fi
    
    # common task
    echo -e "[\033[38;5;33m68%\033[0m] backing up.."
    # backup the image
    mkdir -p $image_backup_dir
    cp $tmp_storage/"kali-nethunter-proot-$SYS_ARCH.tar.xz" $image_backup_dir
    if [ $? -ne 0 ]; then
        print_error "Failed to backup the image file"
        rm -rf $tmp_storage
        exit 1
    else
        echo -e "[\033[38;5;33m75%\033[0m] \033[32;1mdone\033[0m"
    fi
    echo -e "[\033[38;5;33m80%\033[0m] prossing.."
    # Create directory $PREFIX/var/lib/proot-distro/dlcache if it doesn't exist (This will be required if the user is using the Prot distro for the first time)
    mkdir -p $nh_image_path
    
    # Move the compressed archive
    mv $tmp_storage/"kali-nethunter-proot-$SYS_ARCH.tar.xz" $nh_image_path
    if [ $? -ne 0 ]; then
        print_error "Failed to move image file"
        rm -rf $tmp_storage
        exit 1
    else
        echo -e "[\033[38;5;33m90%\033[0m] \033[32;1mdone\033[0m"
    fi
    
    echo -e "[\033[38;5;33m95%\033[0m] cleaning.."
    # Clean up
    rm -rf $tmp_storage
    if [ $? -ne 1 ]; then
        echo -e "[\033[38;5;33m100%\033[0m] \033[32;1mDone\033[0m\n"
    fi
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
    fix_image
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
    if [[ -f $image_backup_dir/kali-nethunter-proot-$SYS_ARCH.tar.xz ]]; then
        print_task "Select nethunter image"
        echo -e "[\033[32m*\033[0m] \033[34mBackup image found.\033[0m"

        echo -e "\n## \033[32;1mOPTIONS\033[0m ##"
        echo -e "\033[38;5;222;1mn\033[0m - Download new nethunter image"
        echo -e "\033[38;5;222;1mb\033[0m - Use the backup image\n"

        printf "[\033[34;1m?\033[0m] Select an option (n/b) : \033[38;5;222m"; read ci
        printf "\033[0m\n"

        case "$ci" in
            n|N)
                rm -rf $image_backup_dir
                pre_installation_process
                ;;
            b|B)
                # copy the backup image
                cp $image_backup_dir/"kali-nethunter-proot-$SYS_ARCH.tar.xz" $nh_image_path
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
    # remove tmp storage
    rm -rf $tmp_storage
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