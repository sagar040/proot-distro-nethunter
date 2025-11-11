# proot-distro-nethunter

The proot-distro-nethunter is a powerful Bash script designed to effortlessly integrate Kali NetHunter into proot-distro. This enables users to deploy multiple NetHunter instances with customized toolsets, akin to managing multiple containers in Docker.

Whether you're a cybersecurity professional or an enthusiast, this installer streamlines the setup process, saving time and effort.

[![Version](https://img.shields.io/badge/version-1.9.2-blue)](https://github.com/sagar040/proot-distro-nethunter/blob/main/install-nethunter.sh)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-orange)](https://raw.githubusercontent.com/sagar040/proot-distro-nethunter/main/LICENSE)
[![Bash](https://img.shields.io/badge/Bash-v5.2.37-green?logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash)


## Preview
[![GUI](https://sagar040.github.io/archives/data/proot-distro-nethunter/images/gui.gif)](https://sagar040.github.io/archives/data/proot-distro-nethunter/images/gui.gif)

## Version 1.9.2

![Bash](https://img.shields.io/badge/-Bash-000000?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Kali Linux](https://img.shields.io/badge/-Kali%20Linux-557C94?style=for-the-badge&logo=kali-linux&logoColor=white)
![Nethunter](https://img.shields.io/badge/-Nethunter-000000?style=for-the-badge&logo=kalilinux&logoColor=white)
![GUI](https://img.shields.io/badge/-GUI-008080?style=for-the-badge&logo=graphical-user-interface&logoColor=white)
![VNC](https://img.shields.io/badge/-VNC-FF6600?style=for-the-badge&logo=vnc&logoColor=white)
![Pentesting](https://img.shields.io/badge/-Pentesting-990000?style=for-the-badge&logo=kali-linux&logoColor=white)
![Cyber Security](https://img.shields.io/badge/-Cyber%20Security-4B0082?style=for-the-badge&logo=security&logoColor=white)
![Installation](https://img.shields.io/badge/-Installation-008000?style=for-the-badge&logo=install&logoColor=white)
![Setup](https://img.shields.io/badge/-Setup-FFD700?style=for-the-badge&logo=setup&logoColor=white)


## ⚠️ Forking
The proot-distro-nethunter software is licensed under the GNU General Public License v3.0. **Any forks or modifications must be distributed under a different name** to avoid confusion with the original software. Using the same name, animation is strictly prohibited.

## Info
- alias name `BUILD ID`
- login shortcut  `<shortcut> [ user ]`
- SHA512SUM of install-nethunter.sh (version 1.9.2) : `992247612be7a336302602795db48520b834e34372c481ad56924aaa62500da0718a856d38ba21a2cb4acb1bad939f7c561245dd1b87c11b43ec9d68b2819045`

## Change logs

- The resource server has been updated from `image-nethunter.kali.org` to [artifacts.kali.org](https://artifacts.kali.org/)
- The command `apt full-upgrade -y` has been changed to `apt upgrade -y` at line number `764` within the `setup_nethunter` function, as the former was causing system instability.

## Features
- **Automated Integration**: Seamlessly integrates Kali NetHunter into proot-distro, eliminating manual configurations.
- **Customization**: Install multiple NetHunters with tailored toolsets, optimized for various tasks.
- **Enhanced UX**: Automatically sets up VNC server for XFCE desktop, enhancing graphical user experience.
- **Efficiency**: Swift installation process reduces manual intervention, making deployment hassle-free.

## What is proot-distro?
<a href="https://github.com/termux/proot-distro/" style="text-decoration: none;color:royalblue;">PRoot Distro</a> is a powerful utility that allows you to run a full Linux distribution on an Android device without the need for root access.

## Requirements

- Android device with Termux installed
- Android version 6 or up
- At least 3 GB of RAM

## How to install termux ?
Click this icon to get latest version of Termux from f-droid

<a href="https://f-droid.org/en/packages/com.termux/">![F-Droid](https://img.shields.io/badge/-F--Droid-0A6EB2?style=for-the-badge&logo=f-droid&logoColor=white)
</a>


## Installation

1. **Update and upgrade Termux**:
    ```bash
    apt update && apt upgrade -y
    ```
3. **Install requirements** :
    ```bash
    apt install git ncurses-utils jq -y
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

## About the configuration file

Configuration file located at `proot-distro-nethunter/config/config.json`

```json
{
    "VERSION": "1.9.2",
    "STORAGE_FAIL_SAFE": true,
    "IMAGE_VERIFICATION": true,
    "IMAGE_FIXING": true,
    "termux_repo_auto": "https://grimler.se/termux/termux-main",
    "nh_image_path": "/data/data/com.termux/files/usr/var/lib/proot-distro/dlcache",
    "nh_rootfs_path": "/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs",
    "image_backup_dir": "/data/data/com.termux/files/home/.pdn-backup",
    "curl_image_path": "file:///data/data/com.termux/files/home/.pdn-backup",
    "old_shortcut_checksum": "e29579e737602bc1114093e306baf41750d38b03e2cf3a25046497ac61ac0082",
    "nh_resource": "https://artifacts.kali.org/images-nethunter/nethunter-fs/",
    "tmp_storage": "/data/data/com.termux/files/home/.prdnh"
}
```
- `VERSION`: Holds only the script version.
- `STORAGE_FAIL_SAFE`: A safety feature to cancel the installation if the device storage is less than the required storage. the default value of this parameter is **true**, set it to **false** if you want to disable the feature (not recommended).
- `IMAGE_VERIFICATION`: A necessary security feature to integrate the downloaded rootfs image file before installing it. the default value of this parameter is **true**, changing the value to **false** will disable this security feature (not recommended).
- `IMAGE_FIXING`: A feature to check the image structure and fix it if necessary, otherwise it will not make any changes to the image file. the default value of this parameter is **true**, changing the value to **false** will skip this checking.
- `termux_repo_auto`: Contains the termux repo url in auto-selection mode.
- `nh_image_path`: Contains the dlcache path of proot-distro.
- `nh_rootfs_path`: Contains the installed rootfs path of proot-distro.
- `image_backup_dir`: Contains the path where the rootfs image file will be stored as backup.
- `curl_image_path`: Contains the backup directory path as a URL.
- `old_shortcut_checksum`: Checksum of old shortcut file (from previous versions).
- `nh_resource`: Contains the URL from which the Kali NetHunter rootfs image and checksum will be downloaded.
- `tmp_storage`: A temporary directory path, where all processes will be run.


## List of kali nethunter builds

### Xfce Builds

| Build ID  | Tools       | System Requirements (RAM GB) | Storage Requirements (GB) | Data Requirements (GB) |
|-----------|-------------|------------------------------|----------------------------|-----------------------|
| KBDEXKMT10| Top10       | 3                            | 6.7                        | 2.0+                  |
| KBDEXKMTD | Default     | 3                            | 13                         | 3.8+                  |
| KBDEXKMTL | Large       | 4                            | 20                         | 4.5+                  |
| KBDEXKMTE | Everything  | 4                            | 34                         | 5.5+                  |

### Custom category builds with xfce desktop

| Build ID  | Tools       | System Requirements (RAM GB) | Storage Requirements (GB) | Data Requirements (GB) |
|-----------|-------------|------------------------------|----------------------------|-----------------------|
| KBCIGDEX  | Information gathering | 2-3                         | 4.8+                          | 1.3+                     |
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
