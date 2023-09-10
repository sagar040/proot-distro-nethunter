# proot-distro-nethunter

## Description
The Proot-Distro NetHunter Installer is a Bash script that automates the integration of Kali NetHunter (official version) with the proot-distro tool. This script simplifies the setup and management of NetHunter distributions within a proot-based environment.

providing security professionals with an easy-to-use setup and management solution for NetHunter distributions.

<h2><a href="https://github.com/sagar040/proot-distro-nethunter/archive/refs/heads/main.tar.gz">Version 1.3.2</a></h2>

**[ ! ] The full version of Nethunter (Full kalifs) is currently unavailable due to some issues.**


## Notes

- the alias name of nethunter can no longer be used as the previous name since version **3.17.0** of proot-distro.

- removed old alias name "nethunter" from script

- replaced alias name as "BackTrack-linux"

- added login shortcut  **nethunter [user]**


## What is proot-distro?
<a href="https://github.com/termux/proot-distro/" style="text-decoration: none;color:royalblue;">PRoot Distro</a> is a powerful utility that allows you to run a full Linux distribution on an Android device without the need for root access. It uses proot, a userspace implementation of chroot, to create a lightweight virtualized environment where you can install and run various Linux distributions.


## Features
The script provides the following key features:

1. Automated integration of Kali NetHunter into proot-distro, eliminating manual configuration steps.
2. Calculation of the SHA256 checksum of the NetHunter rootfs to ensure data integrity during installation.
3. Facilitation of the installation process, providing a straightforward setup experience.
By using this script, users can benefit from:

1. Easy setup and management of Kali NetHunter distributions within a proot-based environment.
2. Swift installation process, reducing manual effort and saving time.


## Prerequisites
Android device with Termux installed

## Installation

Run the following command to install Git (if not already installed):

```bash
pkg install git
```

Clone the repository:
```bash
git clone https://github.com/sagar040/proot-distro-nethunter.git
```

Navigate to the project directory:
```bash
cd proot-distro-nethunter

```

## Usage

Install Kali Nethunter on proot-distro:
```bash
bash install-nethunter.sh --install
```

[![Installer](https://sagar040.github.io/archives/data/proot-distro-nethunter/images/info.png)](https://sagar040.github.io/archives/data/proot-distro-nethunter/images/info.png)

## NetHunter GUI

[![GUI](https://sagar040.github.io/archives/data/proot-distro-nethunter/images/gui2.png)](https://sagar040.github.io/archives/data/proot-distro-nethunter/images/gui2.png)

The Proot-Distro NetHunter Installer provides an option to automatically install and set up the NetHunter GUI environment for a more user-friendly and visual experience. The GUI installation includes the XFCE4 desktop environment, XFCE4 Terminal, Terminator, TigerVNC standalone server, XFCE4 Whisker Menu plugin, and other essential packages.

To automatically install and set up the NetHunter GUI, follow the steps below:

1. After running the installation script with the **`--install`** option, you will be prompted with the option to install the GUI. Respond with **`y`** to proceed with the installation.

2. The script will initiate the installation of the NetHunter GUI packages within the proot-distro environment. This process may take some time, depending on your internet connection speed.

3. Once the installation is complete, the script will proceed to set up the NetHunter GUI environment.

4. The setup process includes configuring the necessary files and settings to ensure a smooth GUI experience. It will also address specific issues like encoding.

5. Finally, the script will display a message confirming the successful installation and setup of the NetHunter GUI.

## Login to NetHunter

1. Run the following command to log in to the NetHunter environment:
    ```bash
    nethunter [user]
    ```
    or
    ```bash
    proot-distro login BackTrack-linux
    ```
## Accessing the NetHunter GUI

2. Once you are logged in, you can start the GUI session by running the following command:
    ```bash
    kgui
    ```

It is important to remember that the NetHunter GUI is optional. If you prefer to use the command-line interface only, you can skip the GUI installation and access NetHunter directly from the command line.
