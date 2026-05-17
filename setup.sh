#!/bin/bash
set -e

# Встановлення пакетів
sudo apt-get install -y gnupg software-properties-common curl wget qemu-system-x86 libvirt-daemon-system libvirt-clients bridge-utils genisoimage dotnet-sdk-10.0 util-linux-extra

# Встановлення Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install terraform

# Встановлення Ansible
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible

# Надавання прав користувачу на використання libvirt
sudo usermod -aG libvirt,kvm $USER

# Створення пулу для libvirt
sg libvirt -c "virsh pool-define-as --name default --type dir --target /var/lib/libvirt/images"
sg libvirt -c "virsh pool-start default"
sg libvirt -c "virsh pool-autostart default"
sg libvirt -c "virsh net-start default"
sg libvirt -c "virsh net-autostart default"

exec newgrp libvirt

echo "Setup completed successfully!"
echo "You can now run Terraform and Ansible"
echo "Consult README.md for further instructions on that"