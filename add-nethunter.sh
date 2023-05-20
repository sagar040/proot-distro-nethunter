#!/data/data/com.termux/files/usr/bin/bash

# Add Kali Nethunter to proot-distro

# This script allows you to easily add Kali Nethunter, a popular penetration testing platform, to the proot-distro tool.
# The script calculates the SHA256 checksum of the rootfs, generates a configuration file for proot-distro, and saves it for seamless integration with the tool.
# With this script, you can quickly set up and manage Kali Nethunter distributions within your proot-based environment for efficient and convenient security testing.

# Author: Sagar Biswas
# GitHub Repository: https://github.com/sagar040/proot-distro-nethunter


# Script version
SCRIPT_VERSION="1.0"

# Check device architecture and set system architecture
get_architecture() {
    supported_arch=("arm64-v8a" "armeabi" "armeabi-v7a")
    device_arch=$(getprop ro.product.cpu.abi)
    supported=false

    printf "\033[34m[*]\033[0m Checking device architecture...\n"

    for arch in "${supported_arch[@]}"; do
        if [[ "$device_arch" == "$arch" ]]; then
            supported=true
            break
        fi
    done

    if $supported; then
        case $device_arch in
            "arm64-v8a")
                SYS_ARCH="arm64"
                ;;
            "armeabi" | "armeabi-v7a")
                SYS_ARCH="armhf"
                ;;
        esac
        printf "\033[34m[*]\033[0m Device architecture: $SYS_ARCH\n"
    else
        echo -e "\033[31m[-]\033[0m Unsupported Architecture!"
        exit 1
    fi
}

# Install required packages
install_packages() {
    printf "\n\033[34m[*]\033[0m Installing required packages...\n"
    apt update && apt upgrade -y
    apt install -y proot-distro curl
}

# Get Nethunter image type from user
select_image_type() {
    echo -e "\n\033[33mnethunter images ($SYS_ARCH)\033[0m"
    echo "[1] nethunter (full)"
    echo "[2] nethunter (minimal)"
    echo "[3] nethunter (nano)"

    read -p "Enter the image you want to add [default: 1]: " image_type

    case "$image_type" in
        1) img="full";;
        2) img="minimal";;
        3) img="nano";;
        *) img="full";;
    esac
}

# Retrieve SHA256 checksum for the selected Nethunter image
get_sha256_checksum() {
    base_url="https://kali.download/nethunter-images/current/rootfs"
    sha256_url="$base_url/SHA256SUMS"
    rootfs="kalifs-$SYS_ARCH-$img.tar.xz"

    printf "\n\033[34m[*]\033[0m Retrieving SHA256 checksum...\n"
    SHA256=$(curl -s "$sha256_url" | grep "$rootfs" | awk '{print $1}')

    if [[ -z "$SHA256" ]]; then
        echo -e "\033[31m[-]\033[0m Failed to retrieve SHA256 checksum. Exiting."
        exit 1
    fi

    printf "\033[34m[*]\033[0m Image file: $rootfs\n"
    printf "\033[34m[*]\033[0m SHA256SUM: $SHA256\n"
}

# Generate and save the proot-distro configuration file
generate_config_file() {
    distro_file="# Kali nethunter $SYS_ARCH ($img)
DISTRO_NAME=\"nethunter\"
DISTRO_COMMENT=\"Kali nethunter $SYS_ARCH ($img)\"
TARBALL_URL['aarch64']=\"$base_url/$rootfs\"
TARBALL_SHA256['aarch64']=\"$SHA256\""

    printf "$distro_file" > $PREFIX/etc/proot-distro/nethunter.sh
}

# Main script
get_architecture
install_packages
select_image_type
get_sha256_checksum
generate_config_file

# Print summary and instructions
printf "\n\033[32m[+]\033[0m Distribution added as nethunter\n"
echo -e "\033[34m[*]\033[0m Script version: $SCRIPT_VERSION"
