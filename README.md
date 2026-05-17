<h1>Лабораторна робота №4</h1>
<h2>Виконав Балалаєв Максим, ІМ-43</h2>

Лабораторну роботу було виконано у середовищі WSL2 (Windows 11) із використанням QEMU.

Використано дистрибутив Ubuntu. Приклад встановлення:
```cmd
wsl --install Ubuntu
```

<h3>Встановлення та попереднє налаштування</h3>
Склонуйте репозиторій та виконайте скрипт setup.sh

```bash
git clone https://github.com/BalalaievMaxim/summer-2026-devops-lab-4
cd summer-2026-devops-lab-4
chmod +x setup.sh
./setup.sh
```
Скрипт встановить усі необхідні залежності, запустить пули для libvirt та перезапустить сесію терміналу

<h3>Виконання</h3>

Виконання Terraform
```bash
cd terraform
terraform init
terraform apply
```
За необхідності використовуйте флаг --auto-approve. Це має розгорнути 2 віртуальні машини (nested virtualization), а також налаштувати ansible/inventory.ini

Виконання Ansible
```bash
cd ../ansible
ansible-playbook -i inventory.ini main.yml
```