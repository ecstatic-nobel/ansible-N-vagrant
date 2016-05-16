#!/bin/bash

set -e

echo -e "\x1B[01;92m Checking if Ansible is installed \x1B[0m"
if [ ! -f /usr/bin/ansible ]
then
    echo -e "\x1B[01;91m Ansible was not found in /usr/bin \x1B[0m"
    exit 1
fi

echo -e "\x1B[01;92m Checking if Git is installed \x1B[0m"
if [ ! -f /usr/bin/git ]
then
    echo -e "\x1B[01;91m Git was not found in /usr/bin \x1B[0m"
    exit 1
fi

echo -e "\x1B[01;92m Checking if Vagrant is installed \x1B[0m"
if [ ! -f /usr/bin/vagrant ]
then
    echo -e "\x1B[01;91m Vagrant was not found in /usr/bin \x1B[0m"
    exit 1
fi

echo -e "\x1B[01;92m Checking if VirtualBox is installed \x1B[0m"
if [ ! -f /usr/bin/virtualbox ]
then
    echo -e "\x1B[01;91m VirtualBox was not found in /usr/bin \x1B[0m"
    exit 1
fi

echo -e "\x1B[01;92m Changing directory to home \x1B[0m"
cd $HOME
echo -e "\x1B[01;92m Creating the ./leunammejii/ansible-N-vagrant directories \x1B[0m"
mkdir -p ./leunammejii/ansible-N-vagrant
echo -e "\x1B[01;92m Changing directory to ./leunammejii/ansible-N-vagrant \x1B[0m"
cd ./leunammejii/ansible-N-vagrant

echo -e "\x1B[01;92m Initializing git reporsitory \x1B[0m"
git init
echo -e "\x1B[01;92m Pulling down the ansible_mini project \x1B[0m"
git pull https://github.com/leunammejii/ansible-N-vagrant.git
echo -e "\x1B[01;92m Making iptables_remote.sh an executable \x1B[0m"
sudo chmod u+x iptables_remote.sh

echo -e "\x1B[01;92m Creating SSH keys in ./home/.ssh \x1B[0m"
ssh-keygen -t rsa -b 4096 -f ./home/.ssh/id_rsa -P ''
echo -e "\x1B[01;92m Changing permissions on ./home/.ssh directory \x1B[0m"
chmod 700 ./home/.ssh
echo -e "\x1B[01;92m Changing permissions on ./home/.ssh directory contents \x1B[0m"
chmod 400 ./home/.ssh/*

echo -e "\x1B[01;92m Making you the owner of /etc/ansible \x1B[0m"
chown -R $USER:$USER /etc/ansible/

echo -e "\x1B[01;92m Creating symbolic links to files in the /etc/ansible/ansible-N-vagrant directory \x1B[0m"
if [ -d /etc/ansible/ansible-N-vagrant ]
then
    ln -sr ./etc/ansible/ansible-N-vagrant/ansible.cfg /etc/ansible/ansible-N-vagrant/
    ln -sr ./etc/ansible/ansible-N-vagrant/hosts1 /etc/ansible/ansible-N-vagrant/hosts
else
    mkdir /etc/ansible/ansible-N-vagrant
    ln -sr ./etc/ansible/ansible.cfg /etc/ansible/ansible-N-vagrant/
    ln -sr ./etc/ansible/hosts1 /etc/ansible/ansible-N-vagrant/hosts
fi

sed -i 's/ ansible_ssh_pass=ansible//' /etc/ansible/ansible-N-vagrant/hosts

echo -e "\x1B[01;92m Changing directory to ./linux_setup \x1B[0m"
cd ./linux_setup

echo -e "\x1B[01;92m Running vagrant up \x1B[0m"
vagrant up --parallel

echo -e "\x1b[01;36m\n The build is complete! Please run the following command to test the setup: \n\x1B[0m"
echo -e "\x1B[01;36m\t cd /etc/ansible/ansible-N-vagrant \x1B[0m"
echo -e "\x1B[01;36m\t ansible all -m ping \n\x1B[0m"
