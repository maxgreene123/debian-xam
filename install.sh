#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Update packages list and update system
apt update
apt upgrade -y

# Install nala
apt install nala -y

# Making config files and movin background to Pictures
cd $builddir
mkdir -p /home/$username/.fonts
mkdir -p /home/$username/Pictures
cp Wallpaper.jpg /home/$username/Pictures/
chown -R $username:$username /home/$username
cd /home/$username/


# Installing Essential Programs 
nala install feh picom thunar thunar-archive-plugin firefox-esr neofetch lightdm gpg lxappearance alsa-tools lxpolkit x11-xserver-utils unzip wget pulseaudio pavucontrol build-essential libx11-dev libxft-dev libxinerama-dev cmake qtbase5-dev qtwebengine5-dev libkf5notifications-dev libkf5xmlgui-dev libkf5globalaccel-dev pkg-config libpipewire-0.3-dev git -y

#discord screen audio install 
git clone https://github.com/maltejur/discord-screenaudio.git
cd discord-screenaudio
cmake -B build
cmake --build build --config Release
cd /home/$username/

#vscode install
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
nala update
nala install code -y

#spotify install
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
nala update
nala install spotify-client -y
cd /home/$username/

#dwm install
mkdir Suckless
cd Suckless
git clone https://github.com/maxgreene123/dwm-xam
cd dwm-xam
make clean install
cd /home/$username/
cd /home/$username/Suckless

#st install
git clone https://github.com/maxgreene123/st-xam
cd st-xam
make clean install
cd /home/$username/
cd /home/$username/Suckless

#sl-status install
git clone https://github.com/maxgreene123/slstatus-xam
cd slstatus-xam
make clean install
cd /home/$username/
cd /home/$username/Suckles

#dmenu install
git clone https://git.suckless.org/dmenu
cd dmenu
make clean install

#dwm desktop entry/xsessionrc setup
cd /home/$username/
cd debian-xam
cp dwm.desktop /usr/share/xsessions/
cp .xsessionrc /home/$username/

# Download Nordic Theme
cd /usr/share/themes/
git clone https://github.com/EliverLara/Nordic.git

# Installing fonts
cd $builddir 
nala install fonts-font-awesome -y
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
unzip JetBrainsMono.zip -d /home/$username/.fonts
mv dotfonts/fontawesome/otfs/*.otf /home/$username/.fonts/
chown $username:$username /home/$username/.fonts/*

# Reloading Font
fc-cache -vf
# Removing zip Files
rm ./JetBrainsMono.zip

# Install Nordzy cursor
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors
./install.sh
cd $builddir
rm -rf Nordzy-cursors

# Enable graphical login and change target from CLI to GUI
systemctl enable lightdm
systemctl set-default graphical.target

# Beautiful bash install
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
