#!/bin/bash

# Update and upgrade the system
sudo apt update
sudo apt upgrade -y

# Install Apache
sudo apt install apache2 -y

# Enable and start Apache
sudo systemctl enable apache2
sudo systemctl start apache2

# Install MySQL Server
sudo apt install mysql-server -y

# Secure MySQL installation (interactive)
sudo mysql_secure_installation

# Install Memcached
sudo apt install memcached -y

# Install PHP and required extensions
sudo apt install php libapache2-mod-php php-mysql php-xml php-gd php-mbstring php-curl php-memcached -y

# Restart Apache to apply PHP configuration
sudo systemctl restart apache2

echo "Installation complete!"
