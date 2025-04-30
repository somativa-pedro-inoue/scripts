#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

echo "=== Starting Custom Software Installation ==="

#############################
### Shared Prerequisites ###
#############################

echo "Installing common prerequisites..."
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release software-properties-common

###################
### Docker Setup ###
###################

echo "Installing Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

# Skip systemctl in chroot
echo "Docker installed. Remember to enable the service on first boot: sudo systemctl enable --now docker"
docker --version

#####################
### Sublime Text ###
#####################

echo "Installing Sublime Text..."
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor -o /usr/share/keyrings/sublimehq-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/sublimehq-archive-keyring.gpg] https://download.sublimetext.com/ apt/stable/" \
  | tee /etc/apt/sources.list.d/sublime-text.list > /dev/null

apt-get update
apt-get install -y sublime-text

if command -v subl >/dev/null 2>&1; then
    echo "Sublime Text installed successfully! Version: $(subl --version)"
else
    echo "Error: Sublime Text installation failed."
    exit 1
fi

######################
### Brave Browser ###
######################

echo "Installing Brave Browser..."
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
  https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] \
https://brave-browser-apt-release.s3.brave.com/ stable main" \
  | tee /etc/apt/sources.list.d/brave-browser-release.list > /dev/null

apt update
apt install -y brave-browser

echo "Brave Browser installed successfully!"

########################
### JetBrains Toolbox ###
########################

echo "Installing JetBrains Toolbox..."
TOOLBOX_URL="https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.2.1.19727.tar.gz"
INSTALL_DIR="/opt/jetbrains-toolbox"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"
curl -L "$TOOLBOX_URL" -o toolbox.tar.gz
tar -xzf toolbox.tar.gz
rm toolbox.tar.gz

# Optionally launch toolbox after ISO boot
chmod +x jetbrains-toolbox-*/jetbrains-toolbox
echo "Toolbox unpacked. Launch it manually after installation: $INSTALL_DIR/jetbrains-toolbox-*/jetbrains-toolbox &"

#################
### Spotify ###
#################

echo "Installing Spotify..."
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | \
  gpg --dearmor | tee /usr/share/keyrings/spotify-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/spotify-archive-keyring.gpg] http://repository.spotify.com stable non-free" \
  | tee /etc/apt/sources.list.d/spotify.list > /dev/null

apt update
apt install -y spotify-client

echo "Spotify installed successfully!"

######################
### All Done ###
######################

echo "=== All installations completed successfully! ==="
