#!/bin/bash

# A script that will create an Ubuntu VM in Azure

# Define variables that will be used in the create vm function
resource_group_name=ubuntuVM
location=eastus2  # Change to a region with lower pricing
vm_name=ubuntu
vm_image=UbuntuLTS
admin_username=azureuser
publisher=canonical

# Create resource group
create_resource_group() {
   echo "Creating resource group: $resource_group_name in $location"
   az group create --name $resource_group_name --location $location | grep provisioningState 
}

# List all resource groups
list_resource_groups() {
    az group list -o table
}

# Create the virtual machine
create_virtual_machine() {
    echo "Creating virtual machine: $vm_name in $location"
    az vm create -g $resource_group_name -n $vm_name --image $vm_image --admin-username $admin_username --generate-ssh-keys -l $location --public-ip-sku Standard --size Standard_B1s | grep provisioningState
}

# Open port 80 for web traffic
open_port_80() {
    az vm open-port --port 80 --resource-group $resource_group_name --name $vm_name
}

# SSH into the virtual machine and install LAMP stack
install_lamp_and_verify() {
    vm_ip_address=$(az network public-ip list --resource-group $resource_group_name --query "[].ipAddress" --output tsv)
    echo "VM IP Address: $vm_ip_address"

    ssh -t $admin_username@$vm_ip_address "
        sudo apt-get update &&
        sudo apt-get -y upgrade &&
        sudo apt-get -y install apache2 mysql-server php libapache2-mod-php php-mysql &&
        sudo systemctl restart apache2 &&
        apache2 -v &&
        mysql -V &&
        php -v
    "
}

# Uncomment the required functions to execute
create_resource_group
list_resource_groups
create_virtual_machine
open_port_80
install_lamp_and_verify
