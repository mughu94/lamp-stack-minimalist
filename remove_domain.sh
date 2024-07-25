#!/bin/bash

# Ask for the domain name
read -p "Enter the domain name to delete (e.g., example.com): " DOMAIN

# Confirm deletion
read -p "Are you sure you want to delete the domain $DOMAIN and its associated data? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
  echo "Operation aborted."
  exit 1
fi

# Variables
WEB_ROOT="/var/www/$DOMAIN"
VHOST_CONF="/etc/apache2/sites-available/$DOMAIN.conf"
DB_NAME=""

# Extract database name from wp-config.php if it exists
if [ -f "$WEB_ROOT/wp-config.php" ]; then
  DB_NAME=$(grep "DB_NAME" $WEB_ROOT/wp-config.php | cut -d \' -f 4)
  DB_USER=$(grep "DB_USER" $WEB_ROOT/wp-config.php | cut -d \' -f 4)
else
  echo "wp-config.php not found. Database details must be removed manually."
fi

# Remove the web root directory
if [ -d "$WEB_ROOT" ]; then
  sudo rm -rf $WEB_ROOT
  echo "Web root directory $WEB_ROOT removed."
else
  echo "Web root directory $WEB_ROOT does not exist."
fi

# Remove the Apache virtual host configuration
if [ -f "$VHOST_CONF" ]; then
  sudo a2dissite $DOMAIN.conf
  sudo rm $VHOST_CONF
  sudo systemctl reload apache2
  echo "Apache virtual host configuration for $DOMAIN removed."
else
  echo "Apache configuration file $VHOST_CONF does not exist."
fi

# Remove the MySQL database and user
if [ ! -z "$DB_NAME" ]; then
  sudo mysql -u root -p -e "DROP DATABASE $DB_NAME;"
  sudo mysql -u root -p -e "DROP USER '$DB_USER'@'localhost';"
  sudo mysql -u root -p -e "FLUSH PRIVILEGES;"
  echo "Database $DB_NAME and user $DB_USER removed."
else
  echo "No database information found or database removal skipped."
fi

echo "Domain $DOMAIN and associated data have been removed."
