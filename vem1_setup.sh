#!/bin/bash

##### ANSIBLE USER SETUP #####

# Create the 'ansible' user, add to 'root' group, and create the '/home/ansible/.ssh' directory.
useradd -c 'Ansible Service' -d /home/ansible -k /etc/skel -m -s /bin/bash -u 1001 -U ansible
echo "ansible:ansible" | chpasswd
usermod -aG root ansible
mkdir /home/ansible/.ssh

# Copy the Vim file.
cp /vagrant/home/.vimrc /home/ansible/.vimrc

# Create SSH key pair and copy to authorized_keys file.
ssh-keygen -t rsa -b 4096 -f /home/ansible/.ssh/id_rsa -P ''
cat /home/ansible/.ssh/id_rsa.pub | tee /home/ansible/.ssh/authorized_keys


##### ANSIBLE SETUP #####

# Install Ansible
apt-get update
apt-get install -y software-properties-common
apt-add-repository -y ppa:ansible/ansible -k keyserver.ubuntu.com
apt-get update
apt-get install --force-yes -y ansible

# Copy copy_keys.yml playbook.
cp /vagrant/etc/ansible/copy_keys.yml /etc/ansible/copy_keys.yml

# Replace the Ansible 'ansible.cfg' and 'hosts' file.
cp /vagrant/etc/ansible/ansible.cfg /etc/ansible/ansible.cfg
sed -i 's/^inventory/#inventory/' /etc/ansible/ansible.cfg
sed -i 's/^private_key_file/#private_key_file/' /etc/ansible/ansible.cfg
cp /vagrant/etc/ansible/hosts1 /etc/ansible/hosts

# Only the 'ansible' user can access files and directories in '/etc/ansible/'
find /etc/ansible/ -type f -exec chmod 600 {} \;
find /etc/ansible/ -type d -exec chmod 700 {} \;
chown -R ansible:ansible /etc/ansible/

# Only the 'ansible' user can access files and directories in '/home/ansible/'
find /home/ansible/ -type f -exec chmod 600 {} \;
find /home/ansible/ -type d -exec chmod 700 {} \;
chown -R ansible:ansible /home/ansible/


##### PACKAGE SETUP #####

# Install Pip and Vim
apt-get install -y python-pip vim


##### SECURITY SETUP #####

# Configure and Save IPTables
/vagrant/iptables_local.sh
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
apt-get install -y iptables-persistent

# Modify the '/etc/sudoers' file.
echo "ansible    ALL=(ALL)    NOPASSWD: ALL" > /etc/sudoers.d/ansible

# Replace the '/etc/pam.d/su' file.
cp /vagrant/etc/pam.d/deb-su /etc/pam.d/su

# Replace the '/etc/ssh/sshd_config' file.
cp /vagrant/etc/ssh/deb-sshd_config /etc/ssh/sshd_config

# Start the SSH service on boot.
update-rc.d ssh defaults

# Copy SSH public key to all machines.
ansible-playbook /etc/ansible/copy_keys.yml

# Replace /etc/ansible/hosts file.
cp -f /vagrant/etc/ansible/hosts2 /etc/ansible/hosts


##### NETWORKING SETUP #####

# Replace and modify the host file
cp /vagrant/etc/hosts /etc/hosts
echo '127.0.0.1    VEM1-ANSIBLE  localhost' >> /etc/hosts


##### EXTRAS #####

# Add command to clear history
echo "alias redbean='history -c && history -w && exit'" >> /etc/bash.bashrc


##### REBOOT #####

# Reboot the system.
reboot now
