# Automated Web Server Setup with WordPress Installation for UBUNTU

This script automates the setup of a LAMP (Linux, Apache, MySQL, PHP) stack on Ubuntu, including the installation of WordPress on a specified domain.

## Prerequisites

- Ubuntu Server (tested on Ubuntu 20 and 22)
- Root or sudo access to the server

### Automatic Installation of LAMP Stack

To automatically install the LAMP stack and set up WordPress:

1. **Download and run the installation script (`install_lamp.sh`):**

    ```bash
    git clone https://github.com/mughu94/lamp-stack-minimalist.git
    chmod +x install_lamp.sh
    ./install_lamp.sh
    ```

   This script will:
   - Update and upgrade the system packages.
   - Install Apache, MySQL, Memcached, PHP, and required extensions.
   - Configure Apache and PHP for WordPress.
   - Optionally set up a new WordPress installation.

### Manual Installation Steps (if not using `install_lamp.sh`)

1. **Update and Upgrade Packages:**

    ```bash
    sudo apt update
    sudo apt upgrade -y
    ```

2. **Install Apache2:**

    ```bash
    sudo apt install apache2 -y
    ```

3. **Start and Enable Apache2 Service:**

    ```bash
    sudo systemctl enable apache2
    sudo systemctl start apache2
    ```

4. **Install MySQL Server and Secure Installation:**

    ```bash
    sudo apt install mysql-server -y
    sudo mysql_secure_installation
    ```

5. **Install Memcached (Optional):**

    ```bash
    sudo apt install memcached -y
    ```

6. **Install PHP and Required Modules:**

    ```bash
    sudo apt install php libapache2-mod-php php-mysql php-xml php-gd php-mbstring php-curl php-memcached -y
    ```

7. **Run the WordPress Setup Script (`setup_wordpress.sh`)**

    - This script interacts with the user to set up a new WordPress installation.
    - It prompts for the domain name and whether to install WordPress.

    ```bash
    ./setup_wordpress.sh
    ```
### `install_lamp.sh` Script Details

- This script automates the installation of Apache, MySQL, PHP, and Memcached.
- It updates and upgrades the system, installs necessary packages, and configures services.
- Optionally sets up a new WordPress installation.
  
## `setup_wordpress.sh` Script Details

- The script `setup_wordpress.sh` automates the setup of WordPress:
  - Asks for the domain name and whether to install WordPress.
  - Generates a random database name, user, and password.
  - Creates MySQL database and user, and configures permissions.
  - Downloads and configures WordPress with generated database credentials.
  - Optionally installs WordPress Salts for enhanced security.
  - Configures Apache virtual host for the specified domain.
  - Enables the site, sets up rewrite rules, and restarts Apache.
 
## `remove_domain.sh` Script Details

- The script `remove_domain.sh` removes:
  - The web root directory associated with the domain.
  - The Apache virtual host configuration file.
  - The MySQL database and user associated with the WordPress installation (if found in `wp-config.php`).

## Notes

- Ensure your server meets the necessary requirements before running the script.
- The script assumes root or sudo privileges for execution.
- Customize the Apache virtual host configuration or WordPress setup as per your specific needs.

Feel free to adjust the instructions or add more details as per your deployment and setup preferences. This structure provides clear guidance on both setting up and removing domains with associated services using your scripts.
