#!/bin/bash

# Ask for the domain name
read -p "Enter your domain name (e.g., example.com): " DOMAIN

# Ask if the user wants to install WordPress
read -p "Do you want to install WordPress? (yes/no): " INSTALL_WP

# Generate random database name, user, and password
DB_NAME="wp_$(openssl rand -hex 6)"
DB_USER="wp_user_$(openssl rand -hex 4)"
DB_PASS="$(openssl rand -base64 12)"

# Create MySQL database and user
sudo mysql -u root -p -e "CREATE DATABASE $DB_NAME;"
sudo mysql -u root -p -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
sudo mysql -u root -p -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
sudo mysql -u root -p -e "FLUSH PRIVILEGES;"

# Create web root directory
WEB_ROOT="/var/www/$DOMAIN"
sudo mkdir -p $WEB_ROOT

if [ "$INSTALL_WP" = "yes" ]; then
  # Download and extract WordPress
  cd $WEB_ROOT
  sudo wget https://wordpress.org/latest.tar.gz
  sudo tar -xvf latest.tar.gz --strip-components=1
  sudo rm latest.tar.gz

  # Set permissions
  sudo chown -R www-data:www-data $WEB_ROOT
  sudo chmod -R 755 $WEB_ROOT

  # Configure WordPress
  sudo mv $WEB_ROOT/wp-config-sample.php $WEB_ROOT/wp-config.php
  sudo sed -i "s/database_name_here/$DB_NAME/" $WEB_ROOT/wp-config.php
  sudo sed -i "s/username_here/$DB_USER/" $WEB_ROOT/wp-config.php
  sudo sed -i "s/password_here/$DB_PASS/" $WEB_ROOT/wp-config.php
  
  # Add WordPress Salts
  SALT=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
  STRING='put your unique phrase here'
  printf '%s\n' "g/$STRING/d" a "$SALT" . w | sudo ed -s wp-config.php
else
  # Create a simple index.html file
  echo "<html><body><h1>Hello, World!</h1></body></html>" | sudo tee $WEB_ROOT/index.html
  sudo chown -R www-data:www-data $WEB_ROOT
fi

# Create Apache virtual host configuration
sudo bash -c "cat > /etc/apache2/sites-available/$DOMAIN.conf <<EOF
<VirtualHost *:80>
    ServerAdmin admin@$DOMAIN
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    DocumentRoot $WEB_ROOT
    <Directory $WEB_ROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/$DOMAIN_error.log
    CustomLog \${APACHE_LOG_DIR}/$DOMAIN_access.log combined
</VirtualHost>
EOF"

# Enable site and rewrite module, then restart Apache
sudo a2ensite $DOMAIN.conf
sudo a2enmod rewrite
sudo systemctl restart apache2

# Output the database credentials
echo "Database Name: $DB_NAME"
echo "Database User: $DB_USER"
echo "Database Password: $DB_PASS"

# Output final message
if [ "$INSTALL_WP" = "yes" ]; then
  echo "WordPress installation completed. Visit http://$DOMAIN to finish setup."
else
  echo "Basic configuration completed. Visit http://$DOMAIN to see your site."
fi
