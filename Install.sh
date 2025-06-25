#!/bin/bash

# Update & install essentials
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget sudo software-properties-common git

# Force DRI3 for VMware acceleration
sudo mkdir -p /etc/X11/xorg.conf.d
cat <<EOF | sudo tee /etc/X11/xorg.conf.d/10-dri3.conf
Section "Device"
    Identifier "VMware SVGA"
    Driver "vmware"
    Option "DRI" "3"
EndSection
EOF

# Install graphical drivers and VM tools
sudo apt install -y open-vm-tools open-vm-tools-desktop xserver-xorg-video-vmware mesa-utils

# Desktop Environments (excluding deepin)
sudo apt install -y kde-standard gnome-core mate-desktop-environment xfce4

# Entertainment / Gaming packages
sudo apt install -y \
  steam winetricks vlc kodi retroarch dolphin-emu pcsx2 \
  chromium firefox-esr libreoffice abiword gimp obs-studio \
  transmission-gtk qbittorrent

# Add Flatpak & Flathub for modern apps
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub org.mozilla.firefox

# Install mpv + yt-dlp for external YouTube playback
sudo apt install -y mpv yt-dlp

# Add i386 architecture for Wine compatibility
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y libgl1-mesa-dri:i386 libgl1:i386

# Optional: Surfshark (CLI-based)
if ! command -v surfshark &> /dev/null; then
  echo "Downloading Surfshark CLI (if available)..."
  curl -fsSL https://downloads.surfshark.com/linux/debian-install.sh -o surfshark-install.sh
  chmod +x surfshark-install.sh && sudo ./surfshark-install.sh || echo "Surfshark install skipped."
fi

# Done
echo "Installation complete. Please reboot for all changes to take effect."
