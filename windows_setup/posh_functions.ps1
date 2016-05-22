# Functions used to manage VMs
# Execute the following command to load functions:
# echo ". $HOME/leunammejii/ansible-N-vagrant/linux_setup/bash_functions.sh" >> $profile

#function vem1 {
#    param (
#    	[Parameter(Mandatory=$true)][string]$port
#    )
#
#    putty -load vem1 -P $port
#}

function start-vbvm {
    param (
	[Parameter(Mandatory=$true)][string]$vmname
    )

    vboxmanage startvm $vmname --type headless
}

function stop-vbvm {
    param (
	[Parameter(Mandatory=$true)][string]$vmname
    )

    vboxmanage controlvm $vmname poweroff
}

function restart-vbvms {
    param (
        [Parameter(Mandatory=$true)][string]$vmname
    )

    vboxmanage controlvm $vmname poweroff
    sleep -s 5
    vboxmanage startvm $vmname --type headless
}

function snap-vbvm {
    param (
	[Parameter(Mandatory=$true)][string]$vmname,
	[Parameter(Mandatory=$true)][string]$name
    )

    vboxmanage snapshot $vmname take $name
}

function restore-vbvm {
    param (
	[Parameter(Mandatory=$true)][string]$vmname,
	[Parameter(Mandatory=$true)][string]$name
    )

    vboxmanage snapshot $vmname restore $name
}

function delsnap-vbvm {
    param (
	[Parameter(Mandatory=$true)][string]$vmname,
	[Parameter(Mandatory=$true)][string]$name
    )

    vboxmanage snapshot $vmname delete $name
}

function start-vbvms {
    param (
	[Parameter(Mandatory=$true)][string]$vmname
    )

    vboxmanage startvm "VEM1-$vmname" --type headless
    vboxmanage startvm "VER1-$vmname" --type headless
    vboxmanage startvm "VER2-$vmname" --type headless
}


function stop-vbvms {
    param (
	[Parameter(Mandatory=$true)][string]$vmname
    )

    vboxmanage controlvm "VEM1-$vmname" poweroff
    vboxmanage controlvm "VER1-$vmname" poweroff
    vboxmanage controlvm "VER2-$vmname" poweroff
}

function restart-vbvms {
    param (
        [Parameter(Mandatory=$true)][string]$vmname
    )

    vboxmanage controlvm "VEM1-$vmname" poweroff
    vboxmanage controlvm "VER1-$vmname" poweroff
    vboxmanage controlvm "VER2-$vmname" poweroff
    sleep -s 5
    vboxmanage startvm "VEM1-$vmname" --type headless
    vboxmanage startvm "VER1-$vmname" --type headless
    vboxmanage startvm "VER2-$vmname" --type headless
}


function snap-vbvms {
    param (
	[Parameter(Mandatory=$true)][string]$vmname,
	[Parameter(Mandatory=$true)][string]$name
    )

    vboxmanage snapshot "VEM1-$vmname" take $name
    vboxmanage snapshot "VER1-$vmname" take $name
    vboxmanage snapshot "VER2-$vmname" take $name
}

function restore-vbvms {
    param (
	[Parameter(Mandatory=$true)][string]$vmname,
	[Parameter(Mandatory=$true)][string]$name
    )

    vboxmanage snapshot "VEM1-$vmname" restore $name
    vboxmanage snapshot "VER1-$vmname" restore $name
    vboxmanage snapshot "VER2-$vmname" restore $name
}

function delsnap-vbvms {
    param (
	[Parameter(Mandatory=$true)][string]$vmname,
	[Parameter(Mandatory=$true)][string]$name
    )

    vboxmanage snapshot "VEM1-$vmname" delete $name
    vboxmanage snapshot "VER1-$vmname" delete $name
    vboxmanage snapshot "VER2-$vmname" delete $name
}
