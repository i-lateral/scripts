#!/bin/bash

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

# Now add .bash_profile
echo "Setting up Bash Profile";
cd ~;
touch .bash_profile;
echo 'PATH=$PATH:~/bin' >> .bash_profile;
