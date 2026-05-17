<h1>Лабораторна робота №4</h1>
<h2>Виконав Балалаєв Максим, ІМ-43</h2>

Лабораторну роботу було виконано у середовищі WSL2 (Windows 11) із використанням QEMU.

Використано дистрибутив Ubuntu.

<h3>Попереднє налаштування</h3>

Встановлення пакетів
```bash
sudo apt-get install -y gnupg software-properties-common curl wget qemu-system-x86 libvirt-daemon-system libvirt-clients bridge-utils genisoimage ansible-core dotnet-sdk-10.0
```

Встановлення Terraform
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install terraform
```

Створення пулу для libvirt
```bash
sudo virsh pool-define-as --name default --type dir --target /var/lib/libvirt/images
sudo virsh pool-start default
sudo virsh pool-autostart default
sudo virsh net-start default
sudo virsh net-autostart default
```

<h3>Виконання</h3>

```bash
cd terraform
terraform init
sudo terraform apply
```
За необхідності використовуйте флаг --auto-approve. Це має розгорнути 2 віртуальні машини (nested virtualization), а також налаштувати ansible/inventory.ini