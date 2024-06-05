# proot-distro-nethunter

The proot-distro-nethunter is a powerful Bash script designed to effortlessly integrate Kali NetHunter into proot-distro. This enables users to deploy multiple NetHunter instances with customized toolsets, akin to managing multiple containers in Docker.

Whether you're a cybersecurity professional or an enthusiast, this installer streamlines the setup process, saving time and effort.

[![Version](https://img.shields.io/badge/version-1.7-blue)](https://github.com/sagar040/proot-distro-nethunter/blob/main/install-nethunter.sh)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-green)](https://raw.githubusercontent.com/sagar040/proot-distro-nethunter/main/LICENSE)
[![Bash](https://img.shields.io/badge/Bash-v5.2.26-green?logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash)


## Preview
[![GUI](https://sagar040.github.io/archives/data/proot-distro-nethunter/images/gui.gif)](https://sagar040.github.io/archives/data/proot-distro-nethunter/images/gui.gif)

## Version 1.7

![Bash](https://img.shields.io/badge/-Bash-000000?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Kali Linux](https://img.shields.io/badge/-Kali%20Linux-557C94?style=for-the-badge&logo=kali-linux&logoColor=white)
![Nethunter](https://img.shields.io/badge/-Nethunter-000000?style=for-the-badge&logo=kalilinux&logoColor=white)
![GUI](https://img.shields.io/badge/-GUI-008080?style=for-the-badge&logo=graphical-user-interface&logoColor=white)
![VNC](https://img.shields.io/badge/-VNC-FF6600?style=for-the-badge&logo=vnc&logoColor=white)
![Pentesting](https://img.shields.io/badge/-Pentesting-990000?style=for-the-badge&logo=kali-linux&logoColor=white)
![Cyber Security](https://img.shields.io/badge/-Cyber%20Security-4B0082?style=for-the-badge&logo=security&logoColor=white)
![Installation](https://img.shields.io/badge/-Installation-008000?style=for-the-badge&logo=install&logoColor=white)
![Setup](https://img.shields.io/badge/-Setup-FFD700?style=for-the-badge&logo=setup&logoColor=white)


## Notes
- alias name `BackTrack-<BUILD ID>`
- login shortcut  `nethunter [ BUILD ID ] [ user ]`

## What's New

- Now you can create multiple Nethunters from the same image with custom tools
- Fixed apt upgrade stuck
- Changed default login user from root to kali (if login by shortcut)
- Added upgrade feature for existing installations. it's automatically detects existing installations and upgrades them.
- Removed blank installation option

## Features
- **Automated Integration**: Seamlessly integrates Kali NetHunter into proot-distro, eliminating manual configurations.
- **Customization**: Install multiple NetHunters with tailored toolsets, optimized for various tasks.
- **Enhanced UX**: Automatically sets up VNC server for XFCE desktop, enhancing graphical user experience.
- **Efficiency**: Swift installation process reduces manual intervention, making deployment hassle-free.

## What is proot-distro?
<a href="https://github.com/termux/proot-distro/" style="text-decoration: none;color:royalblue;">PRoot Distro</a> is a powerful utility that allows you to run a full Linux distribution on an Android device without the need for root access.

## Prerequisites

- Android device with Termux installed

## How to install termux ?
Click the icon to get latest version of Termux from f-droid

<a href="https://f-droid.org/en/packages/com.termux/">![F-Droid](https://img.shields.io/badge/-F--Droid-0A6EB2?style=for-the-badge&logo=f-droid&logoColor=white)
</a>


## Installation

1. **Update and upgrade Termux**:
    ```bash
    apt update && apt upgrade -y
    ```
2. **Install Git** (if not already installed):
    ```bash
    apt install git -y
    ```
3. **Clone the repository**:
    ```bash
    git clone https://github.com/sagar040/proot-distro-nethunter.git
    ```
4. **Navigate to the project directory**:
    ```bash
    cd proot-distro-nethunter
    ```

## Usage

- **For information**:
    ```bash
    bash install-nethunter.sh
    ```
- **To start installation**:
    ```bash
    bash install-nethunter.sh --install
    ```

## List of kali nethunter builds

### Xfce Builds

| Build ID  | Tools       | System Requirements (RAM GB) | Storage Requirements (GB) | Data Requirements (GB) |
|-----------|-------------|------------------------------|----------------------------|-----------------------|
| KBDEXKMT10| Top10       | 3                            | 6.7                        | 2.7+                  |
| KBDEXKMTD | Default     | 3                            | 13                         | 3.8+                  |
| KBDEXKMTL | Large       | 4                            | 20                         | 5.5+                  |
| KBDEXKMTE | Everything  | 4                            | 34                         | 9.0+                  |

### Custom category builds with xfce desktop

| Build ID  | Tools       | System Requirements (RAM GB) | Storage Requirements (GB) | Data Requirements (GB) |
|-----------|-------------|------------------------------|----------------------------|-----------------------|
| KBCIGDEX  | Information gathering | 2-3                         | 4.8+                          | 1.6+                     |
| KBCWGDEX  | Web         | -                            | -                          | -                     |
| KBCCSGDEX | Crypto & Stego| -                            | -                          | -                     |
| KBCPGDEX  | Passwords   | -                            | -                          | -                     |
| KBCFOGDEX | Forensics   | -                            | -                          | -                     |
| KBCFUGDEX | Fuzzing     | -                            | -                          | -                     |
| KBCREGDEX | Reverse engineering | -                       | -                          | -                     |
| KBCSSGDEX | Sniffing & Spoofing | -                       | -                          | -                     |
| KBCEGDEX  | Exploit     | -                            | -                          | -                     |

### Kali Nethunter Custom Tools Build

| Build ID  | Tools       | System Requirements (RAM GB) | Storage Requirements (GB) | Data Requirements (GB) |
|-----------|-------------|------------------------------|----------------------------|-----------------------|
| KBCTDEX   | Xfce, firefox-esr, steghide, sqlmap, autopsy, wireshark, yara, wfuzz, enum4linux, nmap, ncat, cewl, john, wordlists, hydra, ghidra, jd-gui, burpsuite, nikto, wpscan, python3, python3-pip, socat, gobuster, villain, dirb | 2-3          | 7.5           | 2.5           |


## Login to NetHunter

1. **Run the following command to log in to the NetHunter environment**:
    ```bash
    nethunter [ BUILD ID ] [ USER ]
    ```
    or
    ```bash
    proot-distro login BackTrack-< BUILD ID > [ USER ]
    ```

## Accessing the NetHunter GUI

2. **Once you are logged in, you can start the GUI session by running the following command**:
    ```bash
    sudo kgui
    ```

## Feedback

Let me know if you face any problems while running or installing this script. Also, let me know which features you think are the best and what you would like to see in the next updates.
## connect with me
[![Reddit](https://img.shields.io/badge/Reddit-%23FF5700.svg?style=for-the-badge&logo=reddit&logoColor=white)](https://www.reddit.com/user/sagarbiswas1/)
[![Instagram](https://img.shields.io/badge/Instagram-%23E4405F.svg?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/__sagarbiswas/)
