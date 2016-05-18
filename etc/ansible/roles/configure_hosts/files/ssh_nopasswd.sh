#!/bin/bash

##### CONFIGURE SSH #####

# Copy and own SSH authorized key.
cp /vagrant/home/.ssh/id_rsa.pub /home/ansible/.ssh/authorized_keys
chown -R ansible:ansible /home/ansible/.ssh

# Disable password authentication.
sed -i 's/^PasswordAuthentication yes$/PasswordAuthentication no/' /etc/ssh/sshd_config


##### REBOOT #####

# Reboot the system.
reboot now
