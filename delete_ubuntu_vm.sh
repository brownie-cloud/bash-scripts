#!/bin/bash

# A script that will delete the ubuntu vm in Azure

vm_name=ubuntu
resource_group_name=ubuntuVM

# Check if the VM is running and stop it
check_stop_vm(){
    az vm list -d -o table
    az vm stop -n $vm_name -g $resource_group_name --verbose
}

# Delete the vm & resource group
# You can delete individual resources with the delete command, 
# but the safest way to remove all resources in a resource group is with group delete.
delete_vm_group(){
    az group wait -n $resource_group_name --deleted #Deletes the resources in the correct order. wait command shows progress and waits until the deletion is complete 
}

check_stop_vm
delete_vm_group
