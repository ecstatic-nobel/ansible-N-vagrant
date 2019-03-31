#!/bin/bash

# Functions used to manage VMs
# Execute the following command to load functions:
# echo ". $HOME/ecstatic-nobel/ansible-N-vagrant/linux_setup/bash_functions.sh" >> $HOME/.bashrc

function start-vbvm {
    vboxmanage startvm $1 --type headless
}

function stop-vbvm {
    vboxmanage controlvm $1 poweroff
}

function restart-vbvm {
    vboxmanage controlvm $1 poweroff
    sleep 5s
    vboxmanage startvm $1 --type headless
}

function snap-vbvm {
    vboxmanage snapshot $1 take $2
}

function restore-vbvm {
    vboxmanage snapshot $1 restore $2
}

function delsnap-vbvm {
    vboxmanage snapshot $1 delete $2
}

function start-vbvms {
    vboxmanage startvm "VER1-$1" --type headless
    vboxmanage startvm "VER2-$1" --type headless
}


function stop-vbvms {
    vboxmanage controlvm "VER1-$1" poweroff
    vboxmanage controlvm "VER2-$1" poweroff
}

function restart-vbvms {
    vboxmanage controlvm "VER1-$1" poweroff
    vboxmanage controlvm "VER2-$1" poweroff
    sleep 5s
    vboxmanage startvm "VER1-$1" --type headless
    vboxmanage startvm "VER2-$1" --type headless
}


function snap-vbvms {
    vboxmanage snapshot "VER1-$1" take $2
    vboxmanage snapshot "VER2-$1" take $2
}

function restore-vbvms {
    vboxmanage snapshot "VER1-$1" restore $2
    vboxmanage snapshot "VER2-$1" restore $2
}

function delsnap-vbvms {
    vboxmanage snapshot "VER1-$1" delete $2
    vboxmanage snapshot "VER2-$1" delete $2
}
