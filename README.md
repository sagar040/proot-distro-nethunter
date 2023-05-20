# proot-distro-nethunter

This script enables easy integration of Kali Nethunter, a widely-used penetration testing platform, with the proot-distro tool. By automating the process of adding Kali Nethunter to proot-distro, this script simplifies the setup and management of Nethunter distributions within a proot-based environment. It accomplishes this by calculating the SHA256 checksum of the Nethunter rootfs, generating a proot-distro configuration file, and facilitating the installation process.

With the ability to swiftly add and manage Kali Nethunter distributions, security professionals can conveniently conduct efficient security testing within their proot-enabled environments. This script streamlines the process of integrating Nethunter with proot-distro, allowing for seamless security testing workflows.


## proot-distro
<a href="https://github.com/termux/proot-distro/blob/master/README.md" style="text-decoration: none;color:royalblue;">proot-distro</a> is a bash script wrapper for utility proot for easy management of chroot-based Linux distribution installations. It does not require root or any special ROM, kernel, etc.

## install nethunter in proot-distro
run the script `./install-nethunter.sh` or `bash install-nethunter.sh`

## login nethunter
as root user
```bash
proot-distro login nethunter
```
as kali user
```bash
proot-distro login nethunter --user kali
```