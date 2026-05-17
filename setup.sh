# Встановлення пакетів
sudo apt-get install -y gnupg software-properties-common curl wget qemu-system-x86 libvirt-daemon-system libvirt-clients bridge-utils genisoimage dotnet-sdk-10.0

# Встановлення Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install terraform

# Встановлення Ansible
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible

# Створення пулу для libvirt
sudo virsh pool-define-as --name default --type dir --target /var/lib/libvirt/images
sudo virsh pool-start default
sudo virsh pool-autostart default
sudo virsh net-start default
sudo virsh net-autostart default

echo "Setup completed successfully!"
echo "You can now run Terraform and Ansible"
echo "Consult README.md for further instructions on that"