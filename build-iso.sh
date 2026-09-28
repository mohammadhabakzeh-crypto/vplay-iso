#!/usr/bin/env bash
# Builds the bootable VERTLOX V-PLAY live ISO. Run on Arch Linux or in an archlinux container.
set -euo pipefail
[ -f /etc/arch-release ] || { echo "Run this on Arch Linux (or an archlinux container)."; exit 1; }
if [ "$EUID" -ne 0 ]; then exec sudo bash "$0" "$@"; fi
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$(mktemp -d /tmp/vplay-build.XXXXXX)"
P="$WORK/profile"

pacman -Sy --needed --noconfirm archiso
cp -r /usr/share/archiso/configs/releng "$P"

cat "$HERE/packages.add" >> "$P/packages.x86_64"
cp -r "$HERE/airootfs/." "$P/airootfs/"
install -Dm644 "$HERE"/app/{main.js,preload.js,package.json,vplay.html} -t "$P/airootfs/usr/lib/vertlox-vplay/"
mkdir -p "$P/airootfs/etc/systemd/system/multi-user.target.wants"
ln -sf /etc/systemd/system/vplay-setup.service "$P/airootfs/etc/systemd/system/multi-user.target.wants/vplay-setup.service"

sed -i -e 's|^iso_name=.*|iso_name="vertlox-vplay"|' \
       -e 's|^iso_label=.*|iso_label="VERTLOX_VPLAY"|' \
       -e 's|^iso_publisher=.*|iso_publisher="VERTLOX"|' \
       -e 's|^iso_application=.*|iso_application="VERTLOX V-PLAY Live"|' "$P/profiledef.sh"
echo 'file_permissions+=(["/usr/local/bin/vplay-kiosk"]="0:0:755")' >> "$P/profiledef.sh"

mkdir -p "$HERE/out"
mkarchiso -v -w "$WORK/work" -o "$HERE/out" "$P"
rm -rf "$WORK"
echo "Done:"; ls -lh "$HERE"/out/*.iso
