#!/bin/bash

set -e

echo -e "\x1B[01;92m Updating package list \x1B[0m"
sudo apt-get update
echo -e "\x1B[01;92m Install software-properties-common \x1B[0m"
sudo apt-get install -y software-properties-common
echo -e "\x1B[01;92m Adding ansible repository \x1B[0m"
sudo apt-add-repository -y ppa:ansible/ansible -k keyserver.ubuntu.com
echo -e "\x1B[01;92m Updating package list \x1B[0m"
sudo apt-get update
echo -e "\x1B[01;92m Installing Ansible \x1B[0m"
sudo apt-get install -y ansible

echo -e "\x1B[01;92m Recursively copying ./etc/ansible to /etc/ansible \x1B[0m"
cp -r /vagrant/etc/ansible/* /etc/ansible
echo -e "\x1B[01;92m Updating Ansible hosts file path \x1B[0m"
sed -i 's/^inventory.*=.*\/etc\/ansible\/ansible-N-vagrant\/hosts$/inventory      = \/etc\/ansible\/hosts/g' /etc/ansible/ansible.cfg
echo -e "\x1B[01;92m Updating private key path \x1B[0m"
sed -i 's/\$HOME\/ecstatic-nobel\/ansible-N-vagrant\/home\/.ssh\/id_rsa/\$HOME\/.ssh\/id_rsa/g' /etc/ansible/ansible.cfg
echo -e "\x1B[01;92m Adding new hosts to the Ansible hosts file \x1B[0m"
sed -i 's/^#//g' /etc/ansible/hosts

echo -e "\x1B[01;92m Making iptables scripts executables \x1B[0m"
chmod u+x /etc/ansible/roles/windows_setup/files/iptables*

echo -e "\x1B[01;92m Running the windows_setup playbook \x1B[0m"
ansible-playbook /etc/ansible/roles/windows_setup.yml

echo -e "\x1B[01;92m Making the ansible user the Ansible remote user \x1B[0m"
sed -i 's/^remote_user = vagrant$/remote_user = ansible/g' /etc/ansible/ansible.cfg
echo -e "\x1B[01;92m Ensuring skipped hosts are seen during playbook run \x1B[0m"
sed -i 's/^display_skipped_hosts = False/display_skipped_hosts = True/g' /etc/ansible/ansible.cfg
echo -e "\x1B[01;92m Remove password for Ansible hosts file \x1B[0m"
sed -i 's/  ansible_ssh_pass=vagrant//gi' /etc/ansible/hosts

echo -e "\x1b[01;36m\n The build is complete! You can login to VEM1-ANSIBLE as 'ansible' with the password 'ansible' \x1B[0m"
echo -e "\x1b[01;36m\n Please run the following commands to test the setup: \n\x1B[0m"
echo -e "\x1B[01;36m\t putty ansible@172.25.25.4 \x1B[0m"
echo -e "\x1B[01;36m\t ansible all -m ping \n\x1B[0m"

exit 0
