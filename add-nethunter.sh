#!/data/data/com.termux/files/usr/bin/bash

# Add Kali Nethunter to proot-distro

# This script allows you to easily add Kali Nethunter, a popular penetration testing platform, to the proot-distro tool.
# The script calculates the SHA256 checksum of the rootfs, generates a configuration file for proot-distro, and saves it for seamless integration with the tool.
# With this script, you can quickly set up and manage Kali Nethunter distributions within your proot-based environment for efficient and convenient security testing.

# Author: Sagar Biswas
# GitHub Repository: https://github.com/sagar040/proot-distro-nethunter

apt update && apt upgrade -y
apt install proot-distro curl

BASE_URL="https://kali.download/nethunter-images/current/rootfs"
SHA256_URL="$BASE_URL/SHA256SUMS"

echo -e "\033[33mnethunter arm64 images\033[0m"
echo "[1] nethunter (full)"
echo "[2] nethunter (minimal)"
echo "[3] nethunter (nano)"
echo "Default => nethunter (full)"

read -p "Enter the image you want to add: " image_type

case "$image_type" in
    1) img="full";;
    2) img="minimal";;
    3) img="nano";;
    *) img="full";;
esac

rootfs="kalifs-arm64-$img.tar.xz"
SHA256=$(curl -s "$SHA256_URL" | grep "$rootfs" | awk '{print $1}')

distro_file="# Kali nethunter arm64 ($img)
DISTRO_NAME=\"nethunter\"
DISTRO_COMMENT=\"Kali nethunter arm64 ($img)\"
TARBALL_URL['aarch64']=\"$BASE_URL/$rootfs\"
TARBALL_SHA256['aarch64']=\"$SHA256\""

echo "$distro_file" > $PREFIX/etc/proot-distro/nethunter.sh

echo -e "\nImage file => $rootfs"
echo "SHA256SUM  => $SHA256"
echo -e "\033[32mdistribution added as nethunter\033[0m"
echo "run 'proot-distro list' to see."
echo "run 'proot-distro install nethunter' to install it."
