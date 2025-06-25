#!/bin/bash
# Fully Unattended Debian Entertainment/Gaming Setup - Failproof Version
# Hosted on GitHub: https://github.com/david915915/Debian

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (use sudo)"
  exit 1
fi

echo "[+] Updating APT sources..."
sed -i 's/main/main contrib non-free non-free-firmware/' /etc/apt/sources.list
apt update -y && apt upgrade -y || true

# Install core tools
packages=(
  wget curl git sudo software-properties-common apt-transport-https ca-certificates gnupg2 gnupg gdebi
  kde-standard gnome-session mate-desktop-environment xfce4 lightdm
  chromium firefox-esr opera
  vlc kodi gimp
  steam wine wine32 winetricks
  retroarch dolphin-emu pcsx2
  libreoffice abiword
  obs-studio kazam simplescreenrecorder
  qbittorrent transmission-gtk
  synaptic flatpak snapd gnome-software-plugin-flatpak
  open-vm-tools open-vm-tools-desktop xserver-xorg-video-vmware
)

# Enable i386 for Wine/Steam
dpkg --add-architecture i386
apt update || true

# Install each package individually and tolerate failure
for pkg in "${packages[@]}"; do
  echo "[+] Installing $pkg..."
  if ! apt install -y "$pkg"; then
    echo "[!] Failed to install $pkg, skipping."
  fi
done

# Attempt Deepin (may not exist in current repo)
echo "[+] Attempting to install Deepin desktop..."
if ! apt install -y deepin-desktop-environment; then
  echo "[!] Deepin not found, skipping."
fi

# Google Chrome
echo "[+] Installing Google Chrome..."
if wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb; then
  if ! gdebi -n /tmp/chrome.deb; then echo "[!] Chrome install failed"; fi
  rm /tmp/chrome.deb
else
  echo "[!] Failed to download Chrome"
fi

# Cemu (Wii U Emulator)
echo "[+] Installing Cemu..."
mkdir -p /opt/cemu && cd /opt/cemu || true
if wget -O cemu.tar.gz https://cemu.info/releases/cemu_2.0-72.tar.gz; then
  tar -xvzf cemu.tar.gz && rm cemu.tar.gz || true
else
  echo "[!] Failed to download Cemu"
fi

# Yuzu (Switch Emulator)
echo "[+] Installing Yuzu..."
add-apt-repository ppa:team-xos/yuzu -y || true
apt update
if ! apt install -y yuzu; then echo "[!] Yuzu failed to install"; fi

# OBS Studio PPA
add-apt-repository ppa:obsproject/obs-studio -y || true
apt update || true

# Flatpak + Flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
snap install snap-store || true

# Surfshark VPN CLI
echo "[+] Installing Surfshark VPN CLI..."
if curl -fsSL https://downloads.surfshark.com/linux/debian-install.sh -o /tmp/surfshark-install.sh; then
  chmod +x /tmp/surfshark-install.sh
  if ! /tmp/surfshark-install.sh; then echo "[!] Surfshark install failed"; fi
else
  echo "[!] Surfshark script download failed"
fi

# Cleanup
echo "[+] Final cleanup..."
apt autoremove -y && apt clean || true

echo "[✅] Setup complete. Reboot when ready."

# Optional GitHub upload (manual)
# git config --global user.name "Your Name"
# git config --global user.email "you@example.com"
# git init
# git remote add origin https://github.com/david915915/Debian.git
# git add Install.sh
# git commit -m "Final resilient version"
# git branch -M main
# git push -u origin main
