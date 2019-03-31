cd $HOME
mkdir -p ecstatic-nobel\ansible-N-vagrant
cd ecstatic-nobel\ansible-N-vagrant
git init
git pull https://github.com/ecstatic-nobel/ansible-N-vagrant.git
cd windows_setup
vagrant up  
