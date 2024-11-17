# proot-distro-nethunter

The proot-distro-nethunter is a powerful Bash script designed to effortlessly integrate Kali NetHunter into proot-distro. This enables users to deploy multiple NetHunter instances with customized toolsets, akin to managing multiple containers in Docker.

Whether you're a cybersecurity professional or an enthusiast, this installer streamlines the setup process, saving time and effort.

[![Version](https://img.shields.io/badge/version-1.8-blue)](https://github.com/sagar040/proot-distro-nethunter/blob/main/install-nethunter.sh)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-orange)](https://raw.githubusercontent.com/sagar040/proot-distro-nethunter/main/LICENSE)
[![Bash](https://img.shields.io/badge/Bash-v5.2.37-green?logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash)


## Preview
[![GUI](https://sagar040.github.io/archives/data/proot-distro-nethunter/images/gui.gif)](https://sagar040.github.io/archives/data/proot-distro-nethunter/images/gui.gif)

## Version 1.8

![Bash](https://img.shields.io/badge/-Bash-000000?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Kali Linux](https://img.shields.io/badge/-Kali%20Linux-557C94?style=for-the-badge&logo=kali-linux&logoColor=white)
![Nethunter](https://img.shields.io/badge/-Nethunter-000000?style=for-the-badge&logo=kalilinux&logoColor=white)
![GUI](https://img.shields.io/badge/-GUI-008080?style=for-the-badge&logo=graphical-user-interface&logoColor=white)
![VNC](https://img.shields.io/badge/-VNC-FF6600?style=for-the-badge&logo=vnc&logoColor=white)
![Pentesting](https://img.shields.io/badge/-Pentesting-990000?style=for-the-badge&logo=kali-linux&logoColor=white)
![Cyber Security](https://img.shields.io/badge/-Cyber%20Security-4B0082?style=for-the-badge&logo=security&logoColor=white)
![Installation](https://img.shields.io/badge/-Installation-008000?style=for-the-badge&logo=install&logoColor=white)
![Setup](https://img.shields.io/badge/-Setup-FFD700?style=for-the-badge&logo=setup&logoColor=white)


## Notice

The proot-distro-nethunter software is licensed under the **GNU General Public License v3.0**. Any **forks** or **modifications** must be distributed under a **different name** to avoid confusion with the original software. Using the same name, logo, or trademark is strictly prohibited.

## Info
- alias name `BUILD ID`
- login shortcut  `<shortcut> [ user ]`
- SHA512SUM of install-nethunter.sh (version 1.8) : `e052d0b818adf6bfee064b79ee25cbee07a568ae72d4200033bf0822969bd1597931e1a9158c3be40ac010311e5fda091fe1dc50f54cdc6af3e826387169612e`

## Change logs

- Fixed some known issues.
- Script has been redesigned according to the new structure of Kali Nethunter.
- Rebuild Nethunter image to run on Prot distro.
- Added automatic termox-repo change option.
- Added rootfs image verification.
- Added backup for reconstructed image.
- Designed to be more user friendly.
- Each build has a separate login shortcut with their build name.
- Added some security features.
- Some settings options have been changed.
- Changed alias name to only 'BUILD ID'

## Features
- **Automated Integration**: Seamlessly integrates Kali NetHunter into proot-distro, eliminating manual configurations.
- **Customization**: Install multiple NetHunters with tailored toolsets, optimized for various tasks.
- **Enhanced UX**: Automatically sets up VNC server for XFCE desktop, enhancing graphical user experience.
- **Efficiency**: Swift installation process reduces manual intervention, making deployment hassle-free.

## What is proot-distro?
<a href="https://github.com/termux/proot-distro/" style="text-decoration: none;color:royalblue;">PRoot Distro</a> is a powerful utility that allows you to run a full Linux distribution on an Android device without the need for root access.

## Prerequisites

- Android device with Termux installed
- Android version 6 or up
- At least 3 GB of ram
- 6 GB of free storage

## How to install termux ?
Click the icon to get latest version of Termux from f-droid

<a href="https://f-droid.org/en/packages/com.termux/">![F-Droid](https://img.shields.io/badge/-F--Droid-0A6EB2?style=for-the-badge&logo=f-droid&logoColor=white)
</a>


## Installation

1. **Update and upgrade Termux**:
    ```bash
    apt update && apt upgrade -y
    ```
3. **Install Git and ncurses-utils** (if not already installed):
    ```bash
    apt install git ncurses-utils -y
    ```
4. **Clone the repository**:
    ```bash
    git clone https://github.com/sagar040/proot-distro-nethunter.git
    ```
5. **Navigate to the project directory**:
    ```bash
    cd proot-distro-nethunter
    ```

## Usage

- **For information**:
    ```bash
    ./install-nethunter.sh
    ```
    or
    ```bash
    bash install-nethunter.sh
    ```
- **To start installation**:
    ```bash
    ./install-nethunter.sh --install
    ```
    or
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


## List of login shortcuts

| Build ID   | Shortcut                 |
|------------|--------------------------|
| KBDEXKMT10 | kali-top10               |
| KBDEXKMTD  | kali-default             |
| KBDEXKMTL  | kali-large               |
| KBDEXKMTE  | kali-everything          |
| KBCTDEX    | kali-custom              |
| KBCIGDEX   | kali-info-gather         |
| KBCWGDEX   | kali-web                 |
| KBCCSGDEX  | kali-crypto-stego        |
| KBCPGDEX   | kali-pass-enum           |
| KBCFOGDEX  | kali-forensics           |
| KBCFUGDEX  | kali-fuzzing             |
| KBCREGDEX  | kali-reverse-engineering |
| KBCSSGDEX  | kali-sniff-spoof         |
| KBCEGDEX   | kali-exploitation        |


## Login to NetHunter

1. **Run the following command to log in to the NetHunter environment**:
    ```bash
    <shortcut> [ USER ]
    ```
    or
    ```bash
    proot-distro login <build id> [ USER ]
    ```

## Accessing the NetHunter GUI

2. **Once you are logged in, you can start the GUI session by running the following command**:
    ```bash
    sudo kgui
    ```

## Donate

As the developer of this free project, I dedicate my personal time outside of work hours to maintain and enhance it. If you find this script useful and are interested in future developments, consider donations through cryptocurrency. Your contribution will help sustain my efforts and encourage continued innovation.

**XRP**
```
rsgoygoN8jGZhVURJGjCs8DLrBeDpL6uFw
```
**BTC**
```
bc1qzde3x9ypny2qqms238nvy9m6ma2x8l4vj0259f
```
**DOGE**
```
DPKcSVn8UmAHRQVNn4wyMhhGoEpphyNeak
```
**LTC**
```
ltc1qqe33lhxakrj0m5gu5rjznc3d7gzr8fjxjfr06x
```
**USDT (TRC20)**
```
TTrxrL8TzZC5NAfsRpinkWGPuDHtZpvEue
```
**TON**
```
UQD_pYicQCsLYFS8nUv64t-t1l93d4mh-QsOA2OKEXtLMfpb
```

## Feedback

Let me know if you face any problems while running or installing this script. Also, let me know which features you think are the best and what you would like to see in the next updates.

## Connect with me

[![Reddit](https://img.shields.io/badge/Reddit-%23FF5700.svg?style=for-the-badge&logo=reddit&logoColor=white)](https://www.reddit.com/user/sagarbiswas1/)
[![Instagram](https://img.shields.io/badge/Instagram-%23E4405F.svg?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/__sagarbiswas/)
