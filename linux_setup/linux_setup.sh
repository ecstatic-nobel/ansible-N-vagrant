#!/bin/bash

set -e

echo -e "\x1B[01;92m Changing directory to home \x1B[0m"
cd $HOME
echo -e "\x1B[01;92m Creating the ./leunammejii/ directory \x1B[0m"
mkdir ./leunammejii/
echo -e "\x1B[01;92m Changing directory to ./leunammejii/ \x1B[0m"
cd ./leunammejii/

echo -e "\x1B[01;92m Cloning the ansible-N-vagrant project \x1B[0m"
git clone https://github.com/leunammejii/ansible-N-vagrant.git
echo -e "\x1B[01;92m Making iptables_remote.sh an executable \x1B[0m"
sudo chmod u+x ./etc/ansible/roles/linux_setup/files/iptables_remote.sh

echo -e "\x1B[01;92m Creating SSH keys in ./home/.ssh \x1B[0m"
ssh-keygen -t rsa -b 4096 -f ./home/.ssh/id_rsa -P ''
echo -e "\x1B[01;92m Changing permissions on ./home/.ssh directory \x1B[0m"
chmod 700 ./home/.ssh
echo -e "\x1B[01;92m Changing permissions on ./home/.ssh directory contents \x1B[0m"
chmod 600 ./home/.ssh/*

echo -e "\x1B[01;92m Making you the owner of /etc/ansible \x1B[0m"
chown -R $USER:$USER /etc/ansible/

echo -e "\x1B[01;92m Creating symbolic links to files in the /etc/ansible/ansible-N-vagrant directory \x1B[0m"
if [ -d /etc/ansible/ansible-N-vagrant ]
then
    ln -sr ./etc/ansible/ansible.cfg /etc/ansible/ansible-N-vagrant/
    ln -sr ./etc/ansible/hosts /etc/ansible/ansible-N-vagrant/hosts
    ln -sr ./etc/ansible/roles /etc/ansible/ansible-N-vagrant/
else
    mkdir /etc/ansible/ansible-N-vagrant
    ln -sr ./etc/ansible/ansible.cfg /etc/ansible/ansible-N-vagrant/
    ln -sr ./etc/ansible/hosts /etc/ansible/ansible-N-vagrant/hosts
    ln -sr ./etc/ansible/roles /etc/ansible/ansible-N-vagrant/
fi

echo -e "\x1B[01;92m Changing directory to ./linux_setup \x1B[0m"
cd ./linux_setup

echo -e "\x1B[01;92m Running vagrant up \x1B[0m"
vagrant up

echo -e "\x1B[01;92m Waiting for hosts to cooperate \x1B[0m"
while ! ping -c1 172.25.25.2 > /dev/null; do :; done
while ! ping -c1 172.25.25.3 > /dev/null; do :; done

echo -e "\x1B[01;92m Changing directory to /etc/ansible/ansible-N-vagrant \x1B[0m"
cd /etc/ansible/ansible-N-vagrant
echo -e "\x1B[01;92m Provisioning remote hosts with Ansible \x1B[0m"
ansible-playbook ./roles/linux_setup.yml

echo -e "\x1B[01;92m Changing Ansible remote user from vagrant to ansible \x1B[0m"
sed -i 's/^remote_user = vagrant$/remote_user = ansible/g' /etc/ansible/ansible-N-vagrant/ansible.cfg
echo -e "\x1B[01;92m Ensuring skipped hosts are shown \x1B[0m"
sed -i 's/^display_skipped_hosts = False/display_skipped_hosts = True/g' /etc/ansible/ansible-N-vagrant/ansible.cfg
echo -e "\x1B[01;92m Removing passwords from Ansible hosts file \x1B[0m"
sed -i 's/  ansible_ssh_pass=vagrant//gi' /etc/ansible/ansible-N-vagrant/hosts

echo -e "\x1B[01;92m Waiting for hosts to wake up \x1B[0m"
while ! ping -c1 172.25.25.2 > /dev/null; do :; done
while ! ping -c1 172.25.25.3 > /dev/null; do :; done

echo -e "\x1b[01;36m\n The build is complete! Please run the following command to test the setup: \n\x1B[0m"
echo -e "\x1B[01;36m\t cd /etc/ansible/ansible-N-vagrant \x1B[0m"
echo -e "\x1B[01;36m\t ansible all -m ping \n\x1B[0m"
