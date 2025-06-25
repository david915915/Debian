#!/bin/bash
# Debian Unattended Entertainment/Gaming Setup
# Hosted on GitHub: https://github.com/YOUR_USERNAME/debian-entertainment-setup

set -e

# Make sure script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (use sudo)"
  exit 1
fi

echo "[+] Setting up sources..."
sed -i 's/main/main contrib non-free non-free-firmware/' /etc/apt/sources.list
apt update -y && apt upgrade -y

echo "[+] Installing essentials and repos..."
apt install -y wget curl git sudo software-properties-common apt-transport-https ca-certificates gnupg2 gnupg gdebi

echo "[+] Adding i386 architecture for Wine/Steam..."
dpkg --add-architecture i386
apt update

echo "[+] Installing desktop environments..."
DEBIAN_FRONTEND=noninteractive apt install -y \
  kde-standard \
  gnome-session \
  mate-desktop-environment \
  xfce4 \
  deepin-desktop-environment \
  lightdm

echo "[+] Installing web browsers..."
apt install -y chromium firefox-esr opera

echo "[+] Installing Google Chrome..."
wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
gdebi -n /tmp/chrome.deb && rm /tmp/chrome.deb

echo "[+] Installing multimedia tools..."
apt install -y vlc kodi gimp

echo "[+] Installing gaming tools..."
apt install -y steam wine wine32 winetricks

echo "[+] Installing emulators..."
apt install -y retroarch dolphin-emu pcsx2

echo "[+] Installing Cemu (Wii U emulator)..."
mkdir -p /opt/cemu && cd /opt/cemu
wget -O cemu.tar.gz https://cemu.info/releases/cemu_2.0-72.tar.gz
tar -xvzf cemu.tar.gz && rm cemu.tar.gz

echo "[+] Installing Yuzu (Switch emulator)..."
add-apt-repository ppa:team-xos/yuzu -y
apt update && apt install -y yuzu

echo "[+] Installing office tools..."
apt install -y libreoffice abiword

echo "[+] Installing OBS Studio and streaming tools..."
add-apt-repository ppa:obsproject/obs-studio -y
apt update && apt install -y obs-studio kazam simplescreenrecorder

echo "[+] Installing torrent clients..."
apt install -y qbittorrent transmission-gtk

echo "[+] Installing package managers and stores..."
apt install -y synaptic gdebi flatpak snapd gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
snap install snap-store

echo "[+] Installing VMware tools and drivers..."
apt install -y open-vm-tools open-vm-tools-desktop xserver-xorg-video-vmware

echo "[+] Final cleanup..."
apt autoremove -y && apt clean

echo "[✅] Fully unattended installation complete! You may now reboot."

# ================= OPTIONAL: Push your version to GitHub =================
# These steps are safe to share but commented out to prevent auto-execution.
# Uncomment and run if you want to maintain your own version.
#
# echo "[Optional] Upload script to GitHub..."
# git config --global user.name "Your Name"
# git config --global user.email "you@example.com"
# git init
# git remote add origin https://github.com/YOUR_USERNAME/debian-entertainment-setup.git
# git add install.sh
# git commit -m "Initial unattended install script"
# git branch -M main
# git push -u origin main
