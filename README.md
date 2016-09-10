# [ansible-N-vagrant]  
##### Quickly stand up a small Ansible development environment using Vagrant.  

### "Containers are not VMs!!!"  
Yeah, yeah, yeah. We all know that by now. So this project is for the "by the  
book" techies who refuse to SSH into a container.  

#### Description  
This environment is equipped with 2-3 virtual machines built with Vagrant  
'bento' boxes.  

- VER1-ANSIBLE (CentOS 6.7)  
- VER2-ANSIBLE (Ubuntu 14.04)  
- VEM1-ANSIBLE (Ubuntu 14.04) (Windows Only)  

If you are using Linux, your host will be the Ansible control machine. If using  
Windows, VEM1-ANSIBLE (Ubuntu 14.04) will be used as the control machine  
and will have Ansible pre-installed.  

#### Linux Prerequisites    
- Ansible  
- Bash  
- Curl  
- Git  
- Vagrant  
- VirtualBox  

#### Linux Setup  
Open a terminal and run the following command:  
```bash  
bash <(curl -s https://raw.githubusercontent.com/leunammejii/ansible-N-vagrant/master/linux_setup/linux_setup.sh)
```  

To pick up the configurations from the ansible.cfg file in this project, run  
all ansible commands from the /etc/ansible/ansible-N-vagrant directory.  
**Note: You may have to run the initial Ansible command twice before it is  
successful.**  

To execute an Ansible ad-hoc command, run the following command:  
```bash  
ansible all -m MODULE [ OPTIONS [ARGS] ]  

```  

To execute an Ansible playbook, run the following command:  
```bash  
ansible-playbook PLAYBOOK [ OPTIONS [ARGS] ]  
```  

#### Windows Prerequisites  
- Git
- PuTTY  
- Vagrant  
- VirtualBox  

#### Windows Setup  
Open PowerShell (or Command Prompt) and run the following commands:  
```powershell  
iex (New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/leunammejii/ansible-N-vagrant/master/windows_setup/windows_setup.ps1")  
```  
Once the build is complete, login to ```172.25.25.4``` using puTTY as ```ansible```  
with the password ```ansible```. You can also execute the following command  
directly from PowerShell:
```powershell  
putty ansible@172.25.25.4  
```  

Run the following command to test the setup:  
```bash  
ansible all -m ping
```  

#### Login to the console via VirtualBox  
Open VirtualBox as administrator/sudo and login to ```VEM1-ANSIBLE``` as  
```ansible``` with the password ```ansible```. Then, run the following command  
to test the setup:  
```powershell  
ansible all -m ping  
```  
Whether or not you're on Windows, you still have the ability to login to the  
console of the remote machines.  

#### Destroy & Rebuild  

###### Linux  
You can now destroy and rebuild the virtual machines with the following commands:  

```bash  
cd $HOME/leunammejii/ansible-N-vagrant/linux_setup  
vagrant destroy -f  
```  

To remove the project completely, run the following commands:  
```bash  
cd $HOME/leunammejii/ansible-N-vagrant/linux_setup  
vagrant destroy -f  
cd $HOME  
sudo rm -r ./leunammejii/ansible-N-vagrant /etc/ansible/ansible-N-vagrant  
```  

###### Windows  
You can now destroy and rebuild the virtual machines with the following commands:  

```powershell    
cd $HOME\leunammejii\ansible-N-vagrant\windows_setup  
vagrant destroy -f  
```  

To remove the project completely, run the following commands:  
```powershell    
cd $HOME\leunammejii\ansible-N-vagrant\windows_setup  
vagrant destroy -f  
cd $HOME  
rmdir .\leunammejii\ansible-N-vagrant\ -Force -Recurse  
```  
