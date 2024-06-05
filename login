#!/data/data/com.termux/files/usr/bin/bash

if [ -z "$1" ]; then
    echo -e "Usage: nethunter [ ID ] [ USER ]\n"
    exit 1
fi

if [ -n "$2" ]; then
    proot-distro login BackTrack-$1 --user $2
else
    proot-distro login BackTrack-$1 --user kali
fi
