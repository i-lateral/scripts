#!/bin/bash

## Basic Hosting Setup Script, add this to the home directory on the server
## and it will download necissary commands to a bin folder in the home directory
## setup your system path and add the default _ss_environment file.

cd ~;

# First create bin folder
echo "Creating bin dir...";
mkdir 'bin';
cd 'bin';

# Install sake
echo "Installing Sake...";
wget "https://raw.githubusercontent.com/silverstripe/silverstripe-framework/3.6/sake";
chmod +x sake;

# Install sspak
echo "Installing SSPAK...";
wget "https://silverstripe.github.io/sspak/sspak.phar";
chmod +x sspak.phar;
mv sspak.phar sspak;

# Install SSPAK backup script
echo "Installing SSPAK backup...";
wget "https://raw.githubusercontent.com/i-lateral/scripts/master/sspaksimplebackup.sh";
chmod +x sspaksimplebackup.sh;

# Install Silverstripe deployment script
echo "Installing Silverstripe Deployment...";
wget "https://raw.githubusercontent.com/i-lateral/scripts/master/deployment.sh";
chmod +x deployment.sh;

# Now add .bash_profile
echo "Setting up Bash Profile";
cd ~;
touch .bash_profile;
echo 'PATH=$PATH:~/bin' >> .bash_profile;

# Now add _ss_environment
echo "Adding SS Environment";
echo "What is the default domain (WITHOUT HTTP)? ";
read defaultdomain;
echo "What is the DB name? ";
read dbname;
echo "What is the DB username? ";
read dbuser;
echo "What is the DB password? ";
read dbpass;
echo "What is the SS admin email? ";
read adminemail;
echo "What is the SS admin password? ";
read adminpass;

touch _ss_environment.php;
echo -e "<?php
/* What kind of environment is this: development, test, or live (ie, production)? */
define('SS_ENVIRONMENT_TYPE', 'live');

/* Database connection */
define('SS_DATABASE_SERVER', 'localhost');
define('SS_DATABASE_USERNAME', '$dbuser');
define('SS_DATABASE_PASSWORD', '$dbpass');
define('SS_DATABASE_NAME', '$dbname');

/* Command Line Access */
global \$_FILE_TO_URL_MAPPING;
\$_FILE_TO_URL_MAPPING['/var/www/vhosts/$defaultdomain/httpdocs'] = 'http://$defaultdomain';

/* Configure a default username and password to access the CMS on all sites in this environment. */
define('SS_DEFAULT_ADMIN_USERNAME', '$adminemail');
define('SS_DEFAULT_ADMIN_PASSWORD', '$adminpass');" >> _ss_environment.php;

