#!/bin/bash
# Fully Unattended Debian Entertainment/Gaming Setup with Resilience
# Hosted on GitHub: https://github.com/david915915/Debian

# DO NOT use set -e so the script continues even if a command fails

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (use sudo)"
  exit 1
fi

echo "[+] Updating APT sources..."
sed -i 's/main/main contrib non-free non-free-firmware/' /etc/apt/sources.list
apt update -y && apt upgrade -y || true

echo "[+] Installing core utilities and package tools..."
apt install -y wget curl git sudo software-properties-common apt-transport-https ca-certificates gnupg2 gnupg gdebi || true

# Enable 32-bit support
echo "[+] Enabling i386 architecture..."
dpkg --add-architecture i386
apt update || true

# Desktop Environments
echo "[+] Installing desktop environments..."
apt install -y kde-standard || true
apt install -y gnome-session || true
apt install -y mate-desktop-environment || true
apt install -y xfce4 || true
apt install -y lightdm || true

# Deepin Desktop (fail gracefully)
echo "[+] Attempting to install Deepin desktop environment..."
if ! apt install -y deepin-desktop-environment; then
  echo "[!] Deepin not found in current repos. Skipping."
fi

# Browsers
echo "[+] Installing web browsers..."
apt install -y chromium firefox-esr opera || true

# Google Chrome
echo "[+] Installing Google Chrome..."
wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb || true
gdebi -n /tmp/chrome.deb || true
rm /tmp/chrome.deb || true

# Multimedia
echo "[+] Installing multimedia applications..."
apt install -y vlc kodi gimp || true

# Gaming
echo "[+] Installing gaming tools..."
apt install -y steam wine wine32 winetricks || true

# Emulators
echo "[+] Installing emulators..."
apt install -y retroarch dolphin-emu pcsx2 || true

# Cemu
echo "[+] Installing Cemu (Wii U emulator)..."
mkdir -p /opt/cemu && cd /opt/cemu || true
wget -O cemu.tar.gz https://cemu.info/releases/cemu_2.0-72.tar.gz || true
tar -xvzf cemu.tar.gz && rm cemu.tar.gz || true

# Yuzu
echo "[+] Installing Yuzu (Switch emulator)..."
add-apt-repository ppa:team-xos/yuzu -y || true
apt update && apt install -y yuzu || true

# Office
echo "[+] Installing office tools..."
apt install -y libreoffice abiword || true

# OBS and Streaming
echo "[+] Installing OBS Studio and streaming tools..."
add-apt-repository ppa:obsproject/obs-studio -y || true
apt update && apt install -y obs-studio kazam simplescreenrecorder || true

# Torrent Clients
echo "[+] Installing torrent applications..."
apt install -y qbittorrent transmission-gtk || true

# Package Managers
echo "[+] Installing Synaptic, gdebi, flatpak, and snap support..."
apt install -y synaptic gdebi flatpak snapd gnome-software-plugin-flatpak || true
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
snap install snap-store || true

# VMware Tools
echo "[+] Installing VMware tools and graphics drivers..."
apt install -y open-vm-tools open-vm-tools-desktop xserver-xorg-video-vmware || true

# Surfshark VPN
echo "[+] Installing Surfshark VPN CLI..."
curl -fsSL https://downloads.surfshark.com/linux/debian-install.sh -o /tmp/surfshark-install.sh || true
chmod +x /tmp/surfshark-install.sh || true
/tmp/surfshark-install.sh || true

# Clean-up
echo "[+] Final cleanup..."
apt autoremove -y && apt clean || true

echo "[✅] Installation completed. You can now reboot your system."

# Optional: push back to GitHub (manual)
# git config --global user.name "Your Name"
# git config --global user.email "you@example.com"
# git init
# git remote add origin https://github.com/david915915/Debian.git
# git add Install.sh
# git commit -m "Updated resilient installer"
# git branch -M main
# git push -u origin main
