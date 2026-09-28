# VERTLOX V-PLAY live ISO kit
Builds a bootable Arch Linux ISO that starts V-PLAY full-screen (kiosk) with no login.

## Build
- On Arch Linux:  `bash build-iso.sh`   (ISO appears in ./out)
- With Docker:    `docker run --rm --privileged -v "$PWD":/kit archlinux:latest bash -c "cd /kit && pacman -Syu --noconfirm && bash build-iso.sh"`
- GitHub Actions: push this folder to a repo, run the "Build ISO" workflow, download the artifact.

## Run in a VM
Linux 64-bit, 4 GB RAM, 2 CPUs, graphics VMSVGA, 128 MB video memory, 3D acceleration OFF.
Boot the first menu entry. Debug shell: Ctrl+Alt+F2, log in as root (no password).
The live system keeps no data: the setup wizard and accounts reset on every boot.
