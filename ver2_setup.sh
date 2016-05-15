#!/bin/bash

##### ANSIBLE USER SETUP #####

# Create the 'ansible' user, add to 'root' group, and create the '/home/ansible/.ssh' directory.
useradd -c 'Ansible User' -d /home/ansible -k /etc/skel -m -s /bin/bash -u 1001 -U ansible
echo "ansible:ansible" | chpasswd
usermod -aG root ansible
mkdir /home/ansible/.ssh

# Copy the Vim file.
cp /vagrant/home/.vimrc /home/ansible/.vimrc

# Only the 'ansible' user can access files and directories in '/home/ansible/'
find /home/ansible/ -type f -exec chmod 600 {} \;
find /home/ansible/ -type d -exec chmod 700 {} \;
chown -R ansible:ansible /home/ansible/

##### RUN UPDATE #####
apt-get update


##### PACKAGE SETUP #####

# Install Pip and Vim
apt-get install -y python-pip vim


##### SECURITY SETUP #####

# Configure and Save IPTables
/vagrant/iptables_remote.sh
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
apt-get install -y iptables-persistent

# Modify the '/etc/sudoers.d/ansible' file.
echo "ansible    ALL=(ALL)    NOPASSWD:ALL" > /etc/sudoers.d/ansible

# Replace the '/etc/pam.d/su' file.
cp /vagrant/etc/pam.d/deb-su /etc/pam.d/su

# Replace the '/etc/ssh/sshd_config' file.
cp /vagrant/etc/ssh/deb-sshd_config /etc/ssh/sshd_config

# Start the SSH service on boot.
update-rc.d ssh defaults


##### NETWORKING SETUP #####

# Replace and modify the host file
cp /vagrant/etc/hosts /etc/hosts
echo "127.0.0.1    VER2-ANSIBLE  localhost" >> /etc/hosts


##### EXTRAS #####

# Add command to clear history
echo "alias redbean='history -c && history -w && exit'" >> /etc/bash.bashrc
