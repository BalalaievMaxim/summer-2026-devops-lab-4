terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.7.6"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# завантаження базового образу Ubuntu
resource "libvirt_volume" "ubuntu_base" {
  name   = "ubuntu-base.qcow2"
  pool   = "default"
  source = var.ubuntu_image_path
  format = "qcow2"
}

# диск для worker
resource "libvirt_volume" "worker_disk" {
  name           = "worker-disk.qcow2"
  base_volume_id = libvirt_volume.ubuntu_base.id
  pool           = "default"
  size           = 10737418240 # 10 GB
}

# диск для db
resource "libvirt_volume" "db_disk" {
  name           = "db-disk.qcow2"
  base_volume_id = libvirt_volume.ubuntu_base.id
  pool           = "default"
  size           = 10737418240
}

# генерація cloud-init конфігурації для worker
resource "libvirt_cloudinit_disk" "worker_init" {
  name      = "worker_init.iso"
  user_data = templatefile("${path.module}/cloud_init.cfg", { 
    ssh_key  = var.ssh_public_key,
    hostname = "worker"
  })
  pool      = "default"
}

# генерація cloud-init конфігурації для db
resource "libvirt_cloudinit_disk" "db_init" {
  name      = "db_init.iso"
  user_data = templatefile("${path.module}/cloud_init.cfg", { 
    ssh_key  = var.ssh_public_key,
    hostname = "db"
  })
  pool      = "default"
}

# worker VM
resource "libvirt_domain" "worker" {
  name   = "worker-vm"
  memory = "2048"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.worker_init.id

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.worker_disk.id
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
}

# db VM
resource "libvirt_domain" "db" {
  name   = "db-vm"
  memory = "2048"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.db_init.id

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.db_disk.id
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
}

# генерація файлу інвентаря для Ansible
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"
  content  = <<EOT
[workers]
worker ansible_host=${libvirt_domain.worker.network_interface[0].addresses[0]} ansible_user=ansible

[db]
db ansible_host=${libvirt_domain.db.network_interface[0].addresses[0]} ansible_user=ansible
EOT
}

# вивід IP адрес після створення
output "worker_ip" {
  value = libvirt_domain.worker.network_interface[0].addresses[0]
}
output "db_ip" {
  value = libvirt_domain.db.network_interface[0].addresses[0]
}