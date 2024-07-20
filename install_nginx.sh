#!/bin/bash

# Update the package list
echo "Updating package list..."
apt update

# Install necessary packages
echo "Installing necessary packages..."
apt install -y curl gnupg2 ca-certificates lsb-release debian-archive-keyring

# Download and save the NGINX signing key
echo "Downloading and saving the NGINX signing key..."
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

# Use lsb_release to set variables defining the OS and release names, then create an apt source file
echo "Setting OS and release variables..."
OS=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
RELEASE=$(lsb_release -cs)
echo "Creating the apt source file..."
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/${OS} ${RELEASE} nginx" | tee /etc/apt/sources.list.d/nginx.list

# Update package information once more
echo "Updating package information..."
apt update

# Install NGINX
echo "Installing NGINX..."
apt install -y nginx

# Enable NGINX to start at boot
echo "Enabling NGINX to start at boot..."
systemctl enable nginx

# Start NGINX
echo "Starting NGINX..."
nginx

echo "NGINX installation and configuration complete."
